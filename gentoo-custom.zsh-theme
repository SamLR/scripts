function prompt_char {
    if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

PROMPT='%(!.%{$fg_bold[red]%}.%{$fg[yellow]%}%n@)%m %T %{$fg_bold[magenta]%}%(5~|%-2~/.../%1~|%4~) ($(git_super_status)%{$fg_bold[magenta]%}) [$(kubectx_prompt_info)] {${AWS_REGION:-us-east-1}} %_$(prompt_char)%{$reset_color%} '

RPROMPT=''
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
