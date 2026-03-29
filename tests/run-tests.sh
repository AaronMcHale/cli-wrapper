#!/usr/bin/env bash
set -u

# Run all test_ functions in test-*.sh scripts

# Cd to the directory of this script, so it can be run from anywhere
realpath="$(realpath "$0")"
cd "${realpath%/*}"

# Save the current directory if tests need a absolute path reference
TEST_DIR="$PWD"

# Run a test file.
# Uses a subshell so that each test file is isolated.
# Usage: run_tests "test-file.sh"
run_tests() {(
  local test_file="$1"
  echo -e "Running tests in $test_file...\n"
  source "$test_file"

  # As we're running in a subshell, we can use trap to run teardown and print message on exit.
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
      $funcname
      if [[ $? -ne 0 ]]; then
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
  # Only source if file exists and is not empty
  if [[ -f "$test_file" && -s "$test_file" ]]; then
    run_tests "$test_file"
    if [[ $? -ne 0 ]]; then
      exit 1
    fi
  fi
done

echo "All tests passed."
