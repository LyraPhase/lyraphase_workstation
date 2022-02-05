## Use Case Explanation

As a DevOps Engineer, I have found that running Ansible, Terraform, and various other utilities inside a docker container is best in order to ensure every other DevOps Engineer is using the right version of these tools for any given infrastructure as code ([IaC](https://en.wikipedia.org/wiki/Infrastructure_as_Code))) repository. This has the benefits of removing the hard dependency on versioned utilities by just relying on Docker, and insulating against IaC syntax deprecations and future API breakage (As of this writing: Terraform is still `0.x`, so this is likely to happen, and has happened already between Terraform `0.11.x` and `0.12.x`). However, running anything in a container on a private network presents some networking challenges when a process inside the container needs to connect to VPC resources.

Typically, Developers & DevOps engineers access services running within an Amazon VPC through SSH tunnels to a Bastion Host.  As most of the team uses MacOS workstations with Docker for Mac, there is some complexity in setting up networking such that a process inside the container may connect through an SSH tunnel to a Bastion Host and finally to a service within an Amazon VPC.  Historically, Docker on Linux and Docker for Mac have different hypervisor and network namespacing models which adds complexity to support both of these platforms.  Luckily, standards such as `SOCKS5` & `SOCKS5h` and tools such as SSH exist to make this easier.  Yet as with most things in software, support for these standards is not implemented in every tool or programming language.  Note that [Golang support for `socks5h://` protocol does not yet exist](https://github.com/golang/go/issues/13454) in the standard libraries handling network & proxy connections.  However, support for these standards is widely adopted enough in the majority of tools and utilities, and is still useful! 

After Docker for Mac was released, slight differences in the hypervisor and default bridged networking mode from the Linux version of Docker started presenting challenges.  I came across [a way to connect from a docker container to a tunnel running on a Mac OS host](https://forums.docker.com/t/accessing-host-machine-from-within-docker-container/14248/5).  I discovered that, when combined with a [`SOCKS5h` SSH proxy](https://blog.mafr.de/2013/11/24/setting-up-a-socks-proxy-using-openssh/) (**Note the `h`, it's important!**), this allows common utilities such as `curl` to access internal VPC services through this proxy + tunnel!

Here is a diagram of the setup:

![Docker SOCKS5h Proxy Diagram](https://gist.githubusercontent.com/trinitronx/6427d6454fb3b121fc2ab5ca7ac766bc/raw/3ae15b71a550f3b17fc12257322d7e43ab5ba770/docker-socks5h-diagram.svg?sanitize=true)

The way to set this up is to do the following:

1. First, Ensure docker networking is set up to allow access to the host (on MacOS add an alias IP for `lo0`)
2. Set up your SSH tunnel (e.g.: with `DynamicForward` or `-D`) & ensure `SOCKS5` is supported on this port
3. Run your tool in a docker container with appropriate network & proxy settings
4. Tool may now access internal VPC services through the `SOCKS5` proxy port

## Use Case Examples

### Terraform Container Executing Utilities With `socks5h://` Support

For example, in order to run local scripts via terraform or GNU Make (**NOTE:** [Terraform itself does not yet support SOCSK5h](https://github.com/hashicorp/terraform/issues/17754)), you might want to set up a container with `socks5h://` network settings on MacOS:

    # First, set up docker networking
    docker network create -d bridge --subnet 10.1.123.0/22 --gateway 10.1.123.1 bridgenet
        
    # On Mac OSX, this is required to actually access host services via alias IP
    sudo ifconfig lo0 alias 172.16.222.111
    
    # Next, set up your SSH tunnel via DynamicForward or -D
    # Note that your SSH tunnel tool needs to provide SOCKS5h proxy capability (OpenSSH should, SSH Tunnel.app on Mac also does)
    # For example, let's use port 4711 as in the SSH tunneling blog post example
    # Note we are using the alias IP for interface lo0 on Mac OSX
    ssh -f -N -v -D 172.16.222.111:4711 ssh-bastion-host.example.com
    # You should see this line in output:
    #    debug1: Local forwarding listening on 172.16.222.111 port 4711
    
    # Next, run a Terraform docker container on bridgenet
    docker run -it --rm -u $(id -u):$(id -g) \
        -v $HOME/.aws:$HOME/.aws:ro \
        --net=bridgenet \
        --add-host proxy.local:172.16.222.111 \
        -v $HOME:$HOME -e HOME \
        -v $(pwd):/wd -w /wd \
        --entrypoint=/bin/sh alpine:latest
    
    # Check that proxy.local is now set as hostname in the container for the alias IP: 172.16.222.111
    cat /etc/hosts
    # You should see this line:
    #     172.16.222.111  proxy.local
    
    # Now, try accessing an internal VPC service or host via socks5h://
    export ALL_PROXY=socks5h://proxy.local:4711; export HTTPS_PROXY=$ALL_PROXY; export HTTP_PROXY=$ALL_PROXY;
    curl -v http://your-service.vpc.local
    # Optional: Check your WAN Egress IP matches either Public IP of bastion host, or NAT Gateway IP (for private subnets)
    curl -v ifconfig.co



### Alpine Container Running `curl`

For example, you might want to access a web URL that is only resolvable from behind a secure SSH Tunnel (e.g: `-D 172.16.222.111:4711`) to a Bastion Host.  That is to say: you want to access an internal service through a secure `SOCKS5 => SSH Tunnel` proxy.  (e.g.: `some-internal-only-service.local`, which has DNS record that is only resolvable _after_ the proxy host).

Luckily, most Linux and open source utilities support the standard proxy environment variables: `ALL_PROXY`, `HTTP_PROXY`, `HTTPS_PROXY`.  So if you were trying to run `curl https://some-internal-only-service.local` for example:

    docker run -it --rm -u $(id -u):$(id -g) \
        -v $HOME/.aws:$HOME/.aws:ro \
        --net=bridgenet \
        --add-host proxy.local:172.16.222.111 \
        -e ALL_PROXY=socks5h://proxy.local:4711 \
        -e HTTPS_PROXY=socks5h://proxy.local:4711 \
        -e HTTP_PROXY=socks5h://proxy.local:4711 \
        -v $HOME:$HOME -e HOME \
        -v $(pwd):/wd -w /wd \
        alpine:latest curl -v https://some-internal-only-service.local

This uses the `bridgenet` user defined Docker network, and adds an `/etc/hosts` entry **inside the container** mapping `proxy.local` to the example macOS Host loopback adapter `lo0` alias IP.

In this example, `curl` should be able to connect via `*_PROXY` settings, doing DNS lookup after the proxy (e.g: SSH Tunnel to Bastion Host), and finally connect to `some-internal-only-service.local` to get a response!

## Known Issues

- Adding an alias IP to `lo0` interface (e.g.: `sudo ifconfig lo0 alias 172.16.222.111`) does **not persist across a reboot**!
  - The [`lyraphase_workstation::loopback_alias_ip` recipe][1] was built to solve this issue!
  - It creates a `LaunchDaemon` to recreate this alias IP after rebooting macOS
- Most tools built with Golang (e.g. [Terraform](https://github.com/hashicorp/terraform/issues/17754)) do not yet support `socks5h://` proxy URLs.
  - This is due to the known issue in Golang's `x/net/proxy` or "`Dialer`" libraries.
  - So, there is no support yet for these standard `*_PROXY` variables using `socks5h://`.
  - **For example:** without the **`h` form** of SOCKS5 protocol (`socks5h://`), terraform cannot resolve internal AWS VPC DNS names _through the proxy_ such as internal VPC Route53 private zone records.
  - The good news is that whenever this issue is solved upstream in Golang, those tools will also support `SOCKS5h` to tunnel correctly!
- Terraform providers and plugins are implemented as separate Golang binaries
  - If proper proxy support is added in future, each provider & plugin must be upgraded.
  - If API promises are broken, IaC repos become out of date and must be updated.


### Potential Path Forward

There is light at the end of the tunnel! (Pun intended)

There is an [upstream bug in Golang to ask for `socks5h://` support in `x/net/proxy` (golang/go#13454)](https://github.com/golang/go/issues/13454).  If this is ever fixed, perhaps Golang code that uses standard `x/net/proxy` library will _just work_!

[1]: https://github.com/trinitronx/lyraphase_workstation/blob/master/recipes/loopback_alias_ip.rb
