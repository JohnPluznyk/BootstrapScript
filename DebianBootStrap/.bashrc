# ~/.bashrc - optimized for Kitty + i3

# Exit if not interactive
case $- in
    *i*) ;;
      *) return;;
esac

# History settings
HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
shopt -s checkwinsize

# Colors enabled always (Kitty supports 24-bit)
color_prompt=yes

# Enable colorized ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Load aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Fancy PS1 prompt with git branch support
parse_git_branch() {
  git branch 2>/dev/null | grep '^*' | colrm 1 2
}


# Green username, blue current directory **current** 
PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '


#PS1="\[\033[38;5;82m\]\u\[\033[0m\]@\[\033[38;5;81m\]\h \
#\[\033[38;5;226m\]\w\[\033[0m\]\[\033[38;5;214m\]\$( [ -d .git ] && echo ' [$(parse_git_branch)]')\[\033[0m\]\n\$ "
