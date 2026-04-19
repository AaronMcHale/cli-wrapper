#!/usr/bin/env bash

# Tests for warning, error, and success output formatting

setup() {
  # Use Bash builtin printf to write the command script
  printf '%s\n' '#!/usr/bin/env bash' \
    'command_exists "formatting-test" && echo "formatting-test exists"' \
    'warning This is a warning' \
    'error This is an error' \
    'success This is a success' > "$TEST_DIR/../commands/formatting-test.sh"

  # Run the command and store output in a variable for tests
  TEST_FORMATTING_OUTPUT=$("$TEST_DIR/../cli.sh" formatting-test 2>&1)
}

test_command_exists() {
  local expected
  expected="formatting-test exists"
  if [[ "$TEST_FORMATTING_OUTPUT" != *"$expected"* ]]; then
    echo "Output of formatting-test command does not contian expected output."
    echo "Expected:    $expected"
    echo "Full output: $TEST_FORMATTING_OUTPUT"
    return 1
  fi
  return 0
}

test_warning_output() {
  local expected
  expected="This is a warning"
  if [[ "$TEST_FORMATTING_OUTPUT" != *"$expected"* ]]; then
    echo "Output of formatting-test command does not contian expected output."
    echo "Expected:    $expected"
    echo "Full output: $TEST_FORMATTING_OUTPUT"
    return 1
  fi
  return 0
}

test_error_output() {
  local expected
  expected="This is an error"
  if [[ "$TEST_FORMATTING_OUTPUT" != *"$expected"* ]]; then
    echo "Output of formatting-test command does not contian expected output."
    echo "Expected:    $expected"
    echo "Full output: $TEST_FORMATTING_OUTPUT"
    return 1
  fi
  return 0
}

test_success_output() {
  local expected
  expected="This is a success"
  if [[ "$TEST_FORMATTING_OUTPUT" != *"$expected"* ]]; then
    echo "Output of formatting-test command does not contian expected output."
    echo "Expected:    $expected"
    echo "Full output: $TEST_FORMATTING_OUTPUT"
    return 1
  fi
  return 0
}

teardown() {
  rm -f "$TEST_DIR/../commands/formatting-test.sh" || true
}
