---
name: cli-writing-command-script
description: Use this skill when writing a command script, while following repository conventions for shell scripts and helper function usage.
compatibility: Requires Bash and local repository access.
---

Refer to `docs/CLI.md` under "Writing the command script" for authoritative guidance.

Key expectations:
- Start each command script with `#!/usr/bin/env bash`.
- Command scripts do not need to be executable; they will be sourced by `cli.sh`.
- Avoid placing usage or help text inside the command script.
- Use `$CLIROOT` for the CLI script directory and `$CMDROOT` for the command script directory.
- Use `$CMD` to identify the current command name.
- Use `command_exists` to check whether another command exists, when needed.
- Use the helper functions `error`, `warning`, and `success` for consistent output.
- Keep command scripts procedural, exiting early when errors occur.

Verification:
1. Run ShellCheck on any changed shell scripts.
2. Run `./tests/run-tests.sh` from the repository root.
