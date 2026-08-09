---
name: cli-declaring-new-command
description: Use this skill when creating a new CLI command script in the commands directory and register it with cli.sh. Use this skill when adding subcommands that should be discovered automatically by the wrapper.
compatibility: Requires Bash and local repository access.
---

Refer to `docs/CLI.md` under "Declaring a new command" for authoritative guidance.

Steps:
1. Create a new `commands/<command>.sh` file where `<command>` is the command name.
2. Ensure the file ends in `.sh` and does not need to be executable.
3. Keep the implementation procedural: the file will be sourced directly by `cli.sh`.
4. Do not add help or usage logic inside the script; use a `.help.txt` file instead.
5. Use the `cli-writing-command-script` skill to implement the command logic and the `cli-providing-description-help` skill to add help text.

Verification:
1. Verify the new command is discovered by `cli.sh` and `cli.sh list`.
2. Run ShellCheck on any changed shell scripts.
3. Run `./tests/run-tests.sh` from the repository root.
