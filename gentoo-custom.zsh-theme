function prompt_char {
    if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

function current_ruby() {
    rbenv version-name | sed s/system/`ruby --version | cut -f 2 -d ' '`\*/
}

PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)%m %T %{$fg_bold[blue]%}%(5~|%-2~/.../%1~|%4~) $(current_ruby) $(git_prompt_info)%_$(prompt_char)%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
