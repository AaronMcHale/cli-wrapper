---
name: cli-providing-description-help
description: Use this skill when providing command descriptions and help content using `.help.txt` files so cli.sh can display listings and help output.
compatibility: Requires Bash and local repository access.
---

Refer to `docs/CLI.md` under "Providing a description and help information" for authoritative guidance.

Instructions:
1. Create `commands/<command>.help.txt` alongside the command script.
2. Keep the first line concise and descriptive; it will be used as the command description in `cli.sh list` output.
3. The complete contents of the `.help.txt` file are displayed by `cli.sh help <command>`.
4. Keep help content separate from the command script itself.

Verification:
1. Verify that the first line of the `.help.txt` file is displayed in `cli.sh list` output.
2. Verify that the complete contents of the `.help.txt` file are displayed in `cli.sh help <command>` output.
3. Run ShellCheck on any changed shell scripts.
4. Run `./tests/run-tests.sh` from the repository root.
