#!/usr/bin/env bash

teardown() {
  rm "$TEST_DIR/../commands/test-cmd.sh" || true
  rm "$TEST_DIR/../commands/test-cmd.help.txt" || true
  rm "$TEST_DIR/cli-symlink.sh" || true
}

setup() {
  echo 'echo "Test command executed"' > "$TEST_DIR/../commands/test-cmd.sh"
  echo "this is a test command" > "$TEST_DIR/../commands/test-cmd.help.txt"
  echo "this line should not show on the command list" >> "$TEST_DIR/../commands/test-cmd.help.txt"
  ln -s ../cli.sh cli-symlink.sh || true
}

test_cli_output_for_test_cmd() {
  echo "Testing cli.sh output for our test command"
  cd ..
  if [[ "$(./cli.sh)" != *"test-cmd"* ]]; then
    echo "FAIL: Test command test-cmd not found in cli.sh output."
    return 1
  fi
  cd "$TEST_DIR" || { echo "Failed to cd back to tests directory"; return 1; }
}

test_cli_from_tests_dir() {
  echo "Testing running cli.sh from tests directory, to proove that it can be run from anywhere"
  if [[ "$(./../cli.sh)" != *"test-cmd"* ]]; then
    echo "FAIL: Test command test-cmd not found when running from tests dir."
    return 1
  fi
}

test_cli_symlink_from_tests_dir() {
  echo "Testing cli.sh as a symlink from tests directory, to prove that it can be run as a symlink from anywhere"
  if [[ "$(./cli-symlink.sh)" != *"test-cmd"* ]]; then
    echo "FAIL: Test command test-cmd not found when running cli.sh as a symlink from tests dir"
    return 1
  fi
}

test_cli_list_output() {
  echo "Testing list sub-command to check output"
  if [[ "$(./../cli.sh list)" != *"test-cmd"* ]]; then
    echo "FAIL: Test command test-cmd not found in cli.sh list output"
    return 1
  fi
}

test_sourcing_cli_is_silent_and_uses_current_directory() {
  echo "Testing sourcing cli.sh is silent and sets CLIROOT to the current directory"
  local output expected_cli_root
  expected_cli_root="$(cd "$TEST_DIR/.." && pwd)" || return 1
  output=$(bash -c '
    cd "$1" || exit 1
    source "$2"
    command_exists "test-cmd" || exit 1
    printf "%s" "$CLIROOT"
  ' bash "$expected_cli_root" "$expected_cli_root/cli.sh" 2>&1) || {
    echo "FAIL: Sourcing cli.sh did not expose its helpers."
    return 1
  }
  if [[ "$output" != "$expected_cli_root" ]]; then
    echo "FAIL: Expected only CLIROOT ($expected_cli_root), got: $output"
    return 1
  fi
}

test_list_output_for_test_cmd_help() {
  echo "Testing help text file file for test command"
  if [[ "$(./../cli.sh list)" != *"this is a test command"* ]]; then
    echo "FAIL: content not found in cli.sh list output"
    return 1
  fi
}

test_help_output_for_test_cmd() {
  echo "Testing help output for test command"
  if [[ "$(./../cli.sh help test-cmd)" != *"this is a test command"* ]]; then
    echo "FAIL: content not found in cli.sh help output"
    return 1
  fi
}

test_list_only_shows_first_line_of_help_file() {
  echo "Test that a second line in the help file does not show on command list"
  if [[ "$(./../cli.sh list)" = *"this line should not show on the command list"* ]]; then
    echo "FAIL: content not found in cli.sh list output"
    return 1
  fi
}

test_help_shows_all_lines_of_help_file() {
  echo "Test that second line of help file shows when running help test-cmd"
  if [[ "$(./../cli.sh help test-cmd)" != *"this line should not show on the command list"* ]]; then
    echo "FAIL: content not found in cli.sh help output"
    return 1
  fi
}
