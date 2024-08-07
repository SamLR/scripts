function prompt_char {
    if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}


RPROMPT=''
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=") "
ZSH_THEME_TF_PROMPT_PREFIX="<"
ZSH_THEME_TF_PROMPT_SUFFIX="> "
ZSH_THEME_AWS_PROFILE_PREFIX="{"
ZSH_THEME_AWS_PROFILE_SUFFIX="} "

PROMPT='%(!.%{$fg_bold[red]%}.%{$fg[yellow]%}%n@)%m %T %{$fg_bold[magenta]%}%(5~|%-2~/.../%1~|%4~) $(git_super_status)%{$fg_bold[magenta]%}[$(kubectx_prompt_info)] $(tf_prompt_info)$(aws_prompt_info)%_$(prompt_char)%{$reset_color%} '
