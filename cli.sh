#!/usr/bin/env bash
set -u

# Simple CLI wrapper that discovers scripts in the commands/ directory

# Cd to the directory of this script, so it can be run from anywhere
realpath="$(realpath "$0")"
cd "${realpath%/*}"

####################
# Helper functions #
####################

# Prints a warning message without exiting.
# Usage: warning <message>...
warning() {
  local msg="$@"
  printf "\e[43m\e[30m[warning]\e[0m %s\n" "$msg"
}

# Prints a error message without exiting.
# Usage: error <message>...
error() {
  local msg="$@"
  printf "\e[41m\e[39m[error] %s\e[0m\n" "$msg"
}

# Prints a success message without exiting.
# Usage: error <message>...
success() {
  local msg="$@"
  printf "\e[42m\e[30m[success]\e[0m %s\n" "$msg"
}

# Check if a command exists
# Usage: command_exists <command>
# Returns 0 if command exists, 1 otherwise.
command_exists() {
  local needle="$1"
  for v in "${commands[@]}"; do
    [ "$v" = "$needle" ] && return 0
  done
  return 1
}

# Color codes
RESET="\e[0m"
# shellcheck disable=SC2034
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
# shellcheck disable=SC2034
BLUE="\e[34m"

##################
# Command loader #
##################

# Build commands list from commands/*.sh (lowercased, without .sh)
commands=()
if [ -d "commands" ]; then
  for f in commands/*.sh; do
    [ -f "$f" ] || continue
    name=$(basename "$f" .sh)
    name_lc=${name,,}
    commands+=("$name_lc")
  done
fi
commands+=("help" "list")

# CMD is $1 lowercased, default to "list"
CMD=${1:-list}
CMD=${CMD,,}

# Shift all args so $1 no longer equals CMD
shift

if [ "$CMD" = "list" ]; then
  echo -e "${YELLOW}Usage:${RESET}"
  echo "  command [options]"
  echo
  echo -e "${YELLOW}Commands:${RESET}"

  # determine longest command name
  max=0
  for c in "${commands[@]}"; do
    l=${#c}
    [ "$l" -gt "$max" ] && max=$l
  done

  for c in "${commands[@]}"; do
    desc=""
    helpfile="commands/${c}.help.txt"
    if [ -f "$helpfile" ]; then
      IFS= read -r desc < "$helpfile" || true
    fi
    printf "  ${GREEN}%-${max}s${RESET}  %s\n" "$c" "$desc"
  done
  exit 0
fi

if [ "$CMD" = "help" ] || [ "$CMD" = "--help" ]; then
  if [ -z "$1" ]; then
    echo "Display help for a command."
    echo "Usage: help [command]"
    exit 0
  fi
  target=${1,,}
  if command_exists "$target" && [ -f "commands/${target}.help.txt" ]; then
    cat "commands/${target}.help.txt"
    exit 0
  fi
  echo "No help available for $target"
  exit 1
fi

# If CMD not in list, print error and exit 1
if ! command_exists "$CMD"; then
  printf "Command \"%s\" not found. Use list for a list of commands.\n" "$CMD"
  exit 1
fi

# Source the script matching CMD
# shellcheck source=/dev/null
. "commands/${CMD}.sh"
