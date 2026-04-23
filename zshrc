
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh"

source /apollo/env/envImprovement/var/zshrc
export JAVA_HOME=$(dirname $(dirname $(realpath /usr/bin/java)))
export PATH=$JAVA_HOME/bin:$PATH
export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short
SAVEHIST=100000
HISTFILE=~/.zsh_history

fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

for f in SDETools envImprovement AmazonAwsCli OdinTools; do
    if [[ -d /apollo/env/$f ]]; then
    	export PATH=$PATH:/apollo/env/$f/bin
    fi
done

export AUTO_TITLE_SCREENS="NO"

export PROMPT="
%{$fg[white]%}(%D %*) <%?> [%~] $program %{$fg[default]%}
%{$fg[cyan]%}%m %#%{$fg[default]%} "

export RPROMPT=

set-title() {
    echo -e "\e]0;$*\007"
}

ssh() {
    set-title $*;
    /usr/bin/ssh -2 $*;
    set-title $HOST;
}

alias amazon_auth="ssh-add -D && kinit -f && mwinit -o -s && ssh-add"
alias bba='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
alias brc='brazil-recursive-cmd'
alias bws='brazil ws'
alias bwsuse='bws use --gitMode -p'
alias bwscreate='bws create -n'
alias bwsupdate='brazil-recursive-cmd --allPackages --continue "git pull --rebase"; brazil ws --sync --md'
function bwsforcepull {
  local base
  if [ -d src ]; then
    base=src
  elif [ -d ../.brazil-workspace ]; then
    base=.
  else
    echo "Not in a Brazil workspace"
    return 1
  fi
  for dir in "$base"/*/; do
    (cd "$dir" && echo "Pulling ${dir##*/}..." && git pull --rebase || true)
  done
}
alias bws_build="brazil-recursive-cmd -all brazil-build"
alias bws_release="brazil-recursive-cmd -all brazil-build release"
alias brc='brazil-recursive-cmd'
alias brctopo='brc --all "echo \${name}-\${interface}"'
alias bbr='brc brazil-build'
alias bball='brc --allPackages'
alias bbb='brc --allPackages brazil-build'
alias bbra='bbr apollo-pkg'i
alias creds='kinit -f && mwinit -o -s && eval `ssh-agent -s` && ssh-add'
alias ss='eval `ssh-agent -s` && ssh-add'
alias mwo='mwinit -o -s'
alias gb='git branch'
alias gd='git diff'
alias gl='git log'
alias gs='git status'
alias ga='git add .'
alias gr='git pull --rebase'
alias gam='git commit --amend'
alias mossy='/apollo/env/Mossy/bin/mossy'
alias switch_java='sudo alternatives --config java && source ~/.zshrc'
alias bb='brazil-build'
export PATH=$HOME/.toolbox/bin:$PATH

export AWS_EC2_METADATA_DISABLED=true



bbrc () { #recursive build
        brazil-recursive-cmd 'echo "@@@ Building $name" && brazil-build'
}

bbcbbrc () { #recursive clean and build
        brazil-recursive-cmd 'echo "@@@ Building $name" && brazil-build clean && brazil-build'
}

bbbrc () { #recursive build
 brazil-recursive-cmd 'echo "@@@ Building $name" && brazil-build clean && brazil-build build'
}

bbrc_package() {
 brazil-recursive-cmd --package "$1" 'echo "@@@ Building $name" && brazil-build clean && brazil-build build'
}

alias pbcopy='xclip -selection clipboard'
export PATH=/opt/homebrew/bin:$PATH



# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh"

# Added by AIM CLI
export PATH="/local/home/bhadarsh/.aim/mcp-servers:$PATH"

# Set up mise for runtime management
eval "$(/home/bhadarsh/.local/bin/mise activate zsh)"
source ~/.local/share/mise/completions.zsh
alias finch='sudo HOME=/home/bhadarsh DOCKER_CONFIG=/home/bhadarsh/.docker finch'
