cite 'about-alias'
about-alias 'common git abbreviations'

# Original Gist: https://gist.github.com/trinitronx/5979265
# RP Gist: https://gist.github.com/returnpathadmin/dbffee1d3d675f271435
# Function to set git author & committer email addresses based on your cwd
# Uses the very first .gitemail file found while traversing up directories
# Use case: As a developer,
#           Given that I have a .gitemail file in my work directory containing my work email
#           When I am in the work directory
#           Then I should be able to commit with my work email address
#           Given that I have a .gitemail file in my public directory containing my public email
#           When I am in the public directory
#           Then I should be able to commit with my personal email address
# Use case: As an ops team member,
#           Given that we share a single user account for running Ansible playbooks
#           And I have a .gitemail file in my own directory
#           And I have a .gitname file in my own directory
#           When I am in my own directory and I check out the Ansible playbooks repo
#           Then I should be able to commit with my own work email & name
# To use:  alias git='__set_git_email_vars; git'
# (w/hub:  alias git='__set_git_email_vars; hub'
function __set_git_email_vars
{
  local gitemail_file=''
  unset GIT_AUTHOR_EMAIL
  unset GIT_COMMITTER_EMAIL
  p="$(pwd)"
  while [[ "$p" != "$HOME" && "$p" != "/"  && "$p" != "." && "$p" != "" ]]; do
    [ -e "$p/.gitemail" ] && gitemail_file="$p/.gitemail" && break
    [ "$p" == "/" ] && break
    p="$(dirname "$p")"
  done
  if [ -e "$gitemail_file" ]; then
      export GIT_AUTHOR_EMAIL=$(cat "$gitemail_file")
      export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
  fi
}

function __set_git_name_vars
{
  local gitname_file=''
  unset GIT_AUTHOR_NAME
  unset GIT_COMMITTER_NAME
  p="$(pwd)"
  while [[ "$p" != "$HOME" && "$p" != "/"  && "$p" != "." && "$p" != "" ]]; do
    [ -e "$p/.gitname" ] && gitname_file="$p/.gitname" && break
    [ "$p" == "/" ] && break
    p="$(dirname "$p")"
  done
  if [ -e "$gitname_file" ]; then
      export GIT_AUTHOR_NAME=$(cat "$gitname_file")
      export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
  fi
}


# Alias to enable custom git author email based on .gitemail file in closest parent directory
#   Source: http://stackoverflow.com/questions/8337071/different-gitconfig-for-a-given-subdirectory
if [ -e "$(which hub 2>/dev/null)" ]; then
  alias git='__set_git_email_vars; __set_git_name_vars; hub'
else
  alias git='__set_git_email_vars; __set_git_name_vars; git'
fi
