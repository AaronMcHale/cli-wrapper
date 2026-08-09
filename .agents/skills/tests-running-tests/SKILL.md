---
name: tests-running-tests
description: Use this skill when running the repository test suite using the test runner to verify changes and catch regressions.
compatibility: Requires Bash and local repository access.
---

Refer to `docs/Tests.md` under "Running tests" for authoritative guidance.

Instructions:
- Run the test runner from the repository root using `./tests/run-tests.sh`.
- The runner finds shell scripts in `./tests` beginning with `test-` and ending in `.sh`.
- Each test file is sourced in a subshell and functions beginning with `test_` are executed.
- Verify proposed changes by running the tests locally before finalizing them.

Verification:
1. Run shellcheck on any changed shell scripts.
2. Ensure that all test pass.
3. Fix any failures before considering the change complete.
