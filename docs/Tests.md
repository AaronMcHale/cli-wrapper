# Tests

This project includes a simple test runner for writing and running tests in Bash.

## Running tests

To run all tests, run `./tests/run-tests.sh`, this is known as the test runner.

The test runner finds all shell scripts in `./tests` which start with `test-` and end in `.sh`. Each script is sourced and all functions starting `test_` are run.

Each test file is sourced in a sub-shell, this means that variables and functions defined in test files should not leak out of the test file.

## Structure of a test file

A test file may contian:

1. A `setup` function which is responsible for setting up the environment, this could include creating files and folders that are needed for the tests to run. If `setup` exists, the test runner will run it before running any tests, this means test functions do not need to call `setup`.
2. One or more test functions, each test function must start with `test_`.
3. A `teardown` function which is responsible for cleaning up the environment, if `setup` or any test functions create files, directories or make any other changes, `teardown` must undo those and restore the environment. If `teardown` exists, the test runner will run it after all tests complete, or after any tests fail, this means test functions do not need to call `teardown`. Teardown functions should try to always true.

## Writing test functions

Tests functions should be written as follows:
* Test functions must be named starting with `test_`, they will be run automatically by the test runner.
* Use the `setup` function for setting up the environment, doing things like creating files and directories used by tests.
* Use the `teardown` function for restoring the environment, deleting anything created in the `setup` function.
* Test functions must never call `setup` and `teardown`, the test runner will call these.
* Test functions should return `0` if the test is successful, or `1` if the test fails.
* Test functions must never use `exit`, they should always use `return` instead, this ensures control is properly handed back to the test runner. Tests should `return 1` for fail, and `return 0` for success.
* The variable `$TEST_DIR` contains the absolute path to the `tests` directory, this is defined by the test runner.

## Examples

```Bash
# Example setup function
setup() {
  echo 'echo "Test command executed"' > "$TEST_DIR/../commands/test-cmd.sh"
}

# Example test function
test_cli_output_for_test_cmd() {
  echo "Testing cli.sh output for our test command"
  cd ..
  if [[ "$(./cli.sh)" != *"test-cmd"* ]]; then
    echo "FAIL: Test command test-cmd not found in cli.sh output."
    return 1
  fi
  cd "$TEST_DIR" || { echo "Failed to cd back to tests directory"; return 1; }
}

# Example teardown function
teardown() {
  rm "$TEST_DIR/../commands/test-cmd.sh" || true
}
```
