#! /bin/bash

sync_files=(".vimrc" ".zshrc" ".zshenv" ".aliases" ".gitignore_global")

if [ -x "$(command -v colordiff)" ]; then
  diff_cmd=colordiff
else
  diff_cmd=diff
fi

if [ -z $1 ]; then
  for f in ${sync_files[*]};
  do
    echo "diffing ${HOME}/${f} ${PWD}/${f}"
    $diff_cmd "${HOME}/${f}" "${PWD}/${f}"
  done

  $diff_cmd "${HOME}/.oh-my-zsh/custom/themes/gentoo-custom.zsh-theme" "${PWD}/gentoo-custom.zsh-theme"
elif [[ $1 == "--from-home" ]]; then
  echo "Copying files from ${HOME} to here"
  for f in ${sync_files[*]};
  do
    echo "copying ${f} to here"
    cp "${HOME}/${f}" "${PWD}/${f}"
  done
  cp "${HOME}/.oh-my-zsh/custom/themes/gentoo-custom.zsh-theme" "${PWD}/gentoo-custom.zsh-theme"
elif [[ $1 == "--to-home" ]]; then
  echo "Copying files from here to ${HOME}"
  echo "WARNING this will overwrite the versions of these files in ${HOME}"
  for f in ${sync_files[*]};
  do
    echo "copying ${f} to home"
    cp "${PWD}/${f}" "${HOME}/${f}"
  done
  cp "${PWD}/gentoo-custom.zsh-theme" "${HOME}/.oh-my-zsh/custom/themes/gentoo-custom.zsh-theme"
else
  echo -e "Usage: $0 [OPTIONS]\n"
  echo -e "diffs SYNC_FILES between ${HOME} and ${PWD}\n"
  echo -e "OPTIONS"
  echo -e "--to-home\tcopy SYNC_FILES from ${PWD} to ${HOME}"
  echo -e "--from-home\tcopy SYNC_FILES from ${HOME} to ${PWD}"
  echo -e "--help\t\tprint this message"
  echo -e "\nSYNC_FILES: ${sync_files[*]} gentoo-custom.zsh-theme"
fi
