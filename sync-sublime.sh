#! /bin/bash

# declare -a sync_files=( "Default (OSX).sublime-keymap" )
declare -a sync_files=( \
  "Default (OSX).sublime-keymap" \
  "Package Control.sublime-settings" \
  "Preferences.sublime-settings" \
  "footnote-bottom.sublime-snippet" \
  "footnote.sublime-snippet"
)

if [ -x "$(command -v colordiff)" ]; then
  diff_cmd=colordiff
else
  diff_cmd=diff
fi

TGT_ROOT="${HOME}/Library/Application Support/Sublime Text/Packages/User"

if [ -z $1 ]; then
  for f in "${sync_files[@]}";
  do
    echo "diffing ${TGT_ROOT}/${f} ${PWD}/${f}"
    $diff_cmd "${TGT_ROOT}/${f}" "${PWD}/${f}"
  done
elif [[ $1 == "--from-library" ]]; then
  echo "Copying files from ${TGT_ROOT} to here"
  for f in "${sync_files[@]}";
  do
    echo "copying ${f} to here"
    cp "${TGT_ROOT}/${f}" "${PWD}/${f}"
  done
elif [[ $1 == "--to-library" ]]; then
  echo "Copying files from here to ${TGT_ROOT}"
  echo "WARNING this will overwrite the versions of these files in ${TGT_ROOT}"
  for f in "${sync_files[@]}";
  do
    echo "copying ${f} to home"
    cp "${PWD}/${f}" "${TGT_ROOT}/${f}"
  done
else
  echo -e "Usage: $0 [OPTIONS]\n"
  echo -e "diffs SYNC_FILES between ${TGT_ROOT} and ${PWD}\n"
  echo -e "OPTIONS"
  echo -e "--to-library\tcopy SYNC_FILES from ${PWD} to ${TGT_ROOT}"
  echo -e "--from-library\tcopy SYNC_FILES from ${TGT_ROOT} to ${PWD}"
  echo -e "--help\t\tprint this message"
  echo -e "\nSYNC_FILES: ${sync_files[*]}"
fi
