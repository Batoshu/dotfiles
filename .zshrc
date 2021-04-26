#####################
# ZSH Configuration #
#####################

# Add ~/.local/bin to $PATH
export PATH="$HOME/.local/bin:$PATH"

# Enable command completion
autoload -Uz compinit
compinit
setopt COMPLETE_ALIASES
setopt PROMPT_SUBST
setopt CORRECT
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1

# History file
HISTFILE=~/.zshhist
HISTSIZE=2000
SAVEHIST=2000
setopt APPENDHISTORY

# Enable auto cd
setopt AUTOCD

# Variables
export BROWSER="firefox"
export EDITOR="vim"

# Commant correct prompt
SPROMPT="Correct %F{red}%B%R%b%f to %F{green}%B%r%b%f? [%BY%bes/%BN%bo/%BA%bbort/%BE%bdit]"

# Command not found handler
command_not_found_handler() {
	print -P "Command '%F{red}%B$1%b%f' not found."
	exit 127
} 

# Prompt style
if [ $EUID -ne 0 ]; then
	PS_USERNAME="%F{green}%n%f"
	PS_CHAR="%F{white}$%f"
else
	PS_USERNAME="%F{red}%n%f"
	PS_CHAR="%F{white}#%f"
fi

PROMPT="%B$PS_USERNAME@%F{yellow}%m%f %F{gray}%~%f $PS_CHAR%b "

# Aliases
if [ $EUID -ne 0 ]; then
	# A little fix for my amnesia
	alias pacman="sudo pacman"
fi
alias pac="pacman -S"
alias pacu="pacman -Syu"
alias aur="yay -S"

# More colors
# Source: https://wiki.archlinux.org/index.php/Color_output_in_console
alias ls='ls --color=auto'
alias ip='ip -color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
export LESS='-R '

# Autostart sway at login
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ] && [ $EUID -ne 0]; then
	export _JAVA_AWT_WM_NONREPARENTING=1
	export QT_QPA_PLATFORM=wayland-egl
	export ECORE_EVAS_ENGINE=wayland_egl
	export ELM_ENGINE=wayland_egl
	export SDL_VIDEODRIVER=wayland
	export MOZ_DBUS_REMOTE=1

	exec dbus-launch sway > $HOME/.local/log/sway.log
fi
