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

bba='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
alias brc='brazil-recursive-cmd'
alias bws='brazil ws'
alias bwsuse='bws use --gitMode -p'
alias bwscreate='bws create -n'
alias bwsupdate='brazil-recursive-cmd --allPackages "git pull --rebase" && brazil ws --sync --md'
alias brc='brazil-recursive-cmd'
alias brctopo='brc --all "echo \${name}-\${interface}"'
alias bbr='brc brazil-build'
alias bball='brc --allPackages'
alias bbb='brc --allPackages brazil-build'
alias bbra='bbr apollo-pkg'i
alias kf='kinit -f && mwinit -o -s'
alias gb='git branch'
alias gd='git diff'
alias gl='git log'
alias gs='git status'
alias ga='git add .'
alias mossy='/apollo/env/Mossy/bin/mossy'
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
