#include <unistd.h>
int main() {
    setuid(0);
    execle("/bin/bash","bash","/Users/jcuzella/bin/kill_misbehaving_mcafee.sh",(char*) NULL,(char*) NULL);
}
