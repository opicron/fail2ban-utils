# BEGIN select with default script #
#!/bin/bash
# Custom `select` implementation that allows *empty* input.
# Pass the choices as individual arguments.
# Output is the chosen item, or "", if the user just pressed ENTER.
# Example:
#    choice=$(selectWithDefault 'one' 'two' 'three')
selectWithDefault() {

  local item i=0 numItems=$#

  # Print numbered menu items, based on the arguments passed.
  for item; do         # Short for: for item in "$@"; do
    printf '%s\n' "$((++i))) $item"
  done >&2 # Print to stderr, as `select` does.

  # Prompt the user for the index of the desired item.
  while :; do
    printf %s "${PS3-#? }" >&2 # Print the prompt string to stderr, as `select` does.
    read -r index
    # Make sure that the input is either empty or that a valid index was entered.
    [[ -z $index ]] && break  # empty input
    (( index >= 1 && index <= numItems )) 2>/dev/null || { echo "Invalid selection. Please try again." > /dev/null 2>&1; continue; }
    break
  done

  # Output the selected item, if any.
  [[ -n $index ]] && printf %s "${@: index:1}"

}
# END select with default script #

