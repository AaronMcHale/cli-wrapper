#!/usr/bin/env bash
set -u

# Run all test_ functions in test-*.sh scripts

# Cd to the directory of this script, so it can be run from anywhere
realpath="$(realpath "$0")" || { echo "Failed to get realpath"; exit 1; }
cd "${realpath%/*}" || { echo "Failed to cd to script directory"; exit 1; }

# Save the current directory if tests need a absolute path reference
# shellcheck disable=SC2034
TEST_DIR="$PWD"

# Run a test file.
# Uses a subshell so that each test file is isolated.
# Usage: run_tests "test-file.sh"
run_tests() {(
  local test_file="$1"
  echo -e "Running tests in $test_file...\n"
  # shellcheck disable=SC1090
  source "$test_file"

  # As we're running in a subshell, we can use trap to run teardown and print message on exit.
  # shellcheck disable=SC2329
  exit_trap() {
    # If a teardown function is defined, set it to run on EXIT
    if [[ $(declare -F teardown) ]]; then
      echo "Running teardown for $test_file..."
      teardown
    fi
    echo -e "Finished running tests in $test_file.\n"
  }
  trap exit_trap EXIT

  # If a setup function is defined, run it before the tests
  if [[ $(declare -F setup) ]]; then
    echo -e "Running setup for $test_file...\n"
    setup
  fi

  # Discover and run all test_ functions in one loop
  while read -r _ _ funcname; do
    if [[ $funcname == test_* ]]; then
      echo "Running $funcname..."
      if ! $funcname; then
        echo -e "FAIL: $funcname returned a non-zero exit code.\n"
        # We are in subshell, so can exit with 1, and trap will run teardown if defined
        exit 1
      fi
      echo -e "OK\n"
    fi
  done < <(declare -F)
)}

TEST_FILES=(test-*.sh)
for test_file in "${TEST_FILES[@]}"; do
  # Confirm that test_file is a file and is not empty before trying to run it
  if [[ -f "$test_file" && -s "$test_file" ]]; then
    if ! run_tests "$test_file"; then
      exit 1
    fi
  fi
done

echo "All tests passed."
