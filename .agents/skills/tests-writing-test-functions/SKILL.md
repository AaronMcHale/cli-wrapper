---
name: tests-writing-test-functions
description: Use this skill when writing Bash test functions that are automatically discovered by the repository test runner and follow the required return conventions.
compatibility: Requires Bash and local repository access.
---

Refer to `docs/Tests.md` under "Writing test functions" for authoritative guidance.

Instructions:
- Always create test functions in files beginning with `test-` and ending in `.sh` inside the `./tests` directory.
- Test file do not need to be executable; they will be sourced by the test runner.
- Name test functions starting with `test_`.
- Do not call `setup` or `teardown` directly from test functions.
- Use `setup` to create files and folders required for tests and for any variables which should be used by multiple test functions.
- Use `return 0` for success and `return 1` for failure.
- Write code procedurally inside test functions and always return early when errors occur; do not use subshells or pipelines that would prevent returning the correct exit code.
- Do not use `exit` inside test functions.
- Use the `$TEST_DIR` variable when referencing paths in tests.
- Ensure cleanup is performed in `teardown` function when necessary.

Example test file:
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

Verification:
1. Run shellcheck on any changed shell scripts.
2. Run `./tests/run-tests.sh` from the repository root, ensure that the test functions are shown in the output and the tests pass.
3. Fix any failures before considering the change complete.
