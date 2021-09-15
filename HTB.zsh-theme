#  █  █         ▐▌     ▄█▄ █          ▄▄▄▄
#  █▄▄█ ▀▀█ █▀▀ ▐▌▄▀    █  █▀█ █▀█    █▌▄█ ▄▀▀▄ ▀▄▀
#  █  █ █▄█ █▄▄ ▐█▀▄    █  █ █ █▄▄    █▌▄█ ▀▄▄▀ █▀█
#
#  P  E  N   -   T  E  S  T  I  N  G     L  A  B  S
#  HTB ZSH theme
#  This is modified from https://gist.github.com/MadLittleMods/2dc87634c6f3649852fba89b9b98e366#file-eric-zsh-theme
#  Modifier: triki
#  Date: 06-16-20

# Custom Colors
green='82'
blue='50'
red='10'
orange='202'
yellow='11'
CURRENT_BG='NONE'

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  SEGMENT_SEPARATOR_TOP='╭─['
  SEGMENT_SEPARATOR_BOT='╰─'
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ $UID -eq 0 ]]; then
    echo -n "%{%f%} %{%k%F{$red}%}#"
  else
    echo -n "%{%f%} %{%k%F{white}%}$"
  fi 
  CURRENT_BG=''
}

# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ "$USER" != "root" ]]; then
    echo -n "%(!.%{%F{red}%}.)%{%k%F{white}%}$USER%{%k%F{$green}%}@%{%k%F{white}%}%m%{%k%F{$green}%}]-["
  else
    echo -n "%(!.%{%F{red}%}.)%{%k%F{$red}%}$USER%{%k%F{$green}%}@%{%k%F{$blue}%}%m%{%k%F{$green}%}]-["
  fi
}

# Dir: current working directory
prompt_dir() {
  echo -n  '%{%k%F{blue}%}%~%{%k%F{$green}%}]'
}

# VPN: htb vpn location
prompt_vpn_loc() {
 #this script can be found here https://github.com/theGuildHall/pwnbox
  htb_vpn_loc=`/opt/vpnserver.sh`
  if 
  echo -n  "%{%k%F{white}%}${htb_vpn_loc}%{%k%F{$green}%}]-["
}

# wlan0
prompt_wlo1()
{
	echo -n "%{%k%F{$yellow}%}`ip addr show dev $(ip route ls|awk '/default/ {print $5}')|grep -Po 'inet \K(\d{1,3}\.?){4}'`%{%k%F{$green}%}]-["
}

# tun0
prompt_tun0()
{
    if [[ $(ip addr | grep -i tun0) ]]; then
	  echo -n "%{%k%F{$yellow}%}`ip addr show dev tun0 |grep -Po 'inet \K(\d{1,3}\.?){4}'`%{%k%F{$green}%}]-[";
    else
      echo -n "";
    fi
}
prompt_time()
{
 	echo -n "$(date +%H:%M:%S)]-["
}
# VPN: htb vpn IP
prompt_vpn_ip() {
   #this script can be found here https://github.com/theGuildHall/pwnbox
   htb_vpn_ip=`/opt/vpnbash.sh`
   echo -n "%{%k%F{white}%}${htb_vpn_ip}%{%k%F{$green}%}]-["
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    echo -n  "(`basename $virtualenv_path`)"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  FAIL_CHAR=$'\u2622'
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{$red}%}${FAIL_CHAR}"
  [[ $UID -eq 0 ]] && symbols+="%{%F{$red}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && echo -n "%{%F{$green}%}[$symbols%{%F{$green}%}]"
}

prompt_newline() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n "%{%k%F{$CURRENT_BG}%}
%{%k%F{$green}%}$SEGMENT_SEPARATOR_BOT"
  else
    echo -n "%{%k%}"
  fi

  echo -n "%{%f%}"
  CURRENT_BG=''
}

prompt_spacer() {
  echo -n "%{%k%F{$green}%}]-["
}

prompt_header() {
  echo -n "%{%k%F{$green}%}$SEGMENT_SEPARATOR_TOP"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_header
  #prompt_vpn_loc
  prompt_time
  prompt_wlo1
  prompt_tun0
  #prompt_vpn_ip
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_newline
  prompt_status
  prompt_end
}

PROMPT='%{%f%k%}$(build_prompt) '

#PROMPT='%{%f%k%}$(build_prompt) '


