#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Custom alias configs
test -f ~/.aliases && . ~/.aliases

# Starship
eval "$(starship init bash)"
