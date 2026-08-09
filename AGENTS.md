# AGENTS

This repository exposes its agent skills under `.agents/skills/`.
Agents should use those skill definitions instead of relying on local heuristics or separate guidance.

## Use these skills

- `.agents/skills/cli-declaring-new-command`
- `.agents/skills/cli-writing-command-script`
- `.agents/skills/cli-providing-description-help`
- `.agents/skills/tests-running-tests`
- `.agents/skills/tests-structure-of-a-test-file`
- `.agents/skills/tests-writing-test-functions`
- `.agents/skills/tests-examples`

## Required workflow

After any code or documentation change, run:

1. ShellCheck on the changed shell scripts.
2. `./tests/run-tests.sh`

If either check fails, fix the issues before considering the change complete.
