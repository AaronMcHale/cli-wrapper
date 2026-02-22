# CLI Wrapper

A simple CLI script for wrapping Bash scripts in a single command.

## Who is this for

I created this template project because I wanted to have a simple CLI wrapper for some of my other projects.

So this could be useful for any project which wants to ship a single entrypoint script to a bunch of different scripts.

## Features

* A simple `cli.sh` script which handles displaying a list of commands, help information and running scripts as sub-commands.
* Builtin `list` and `help` sub-commands.
* Any `.sh` scripts in the `commands` directory will be registered automatically as sub-commands.
* Scripts in the `commands` directory can also provide a `.help.txt` file which is displayed when running the `help` sub-command, and the first line of the file is used as the description in the command `list`.
* Most existing Bash scripts will work as is, no special functions are needed, scripts are sourced and invoked arguments are shifted before command script is sourced, so `$2` becomes `$1` for the command script.
* Formatting variables for `RESET` `RED` `GREEN` `YELLOW` `BLUE` are provided.
* The `cli.sh` script supports being run from anywhere in the system. For example, this means it can be symlinked to `/usr/bin` and it will work.

## Docs

[Read the CLI docs for more information on how commands works.](docs/CLI.md)

## Using this template in your project

1. Start by copying the contents of this repository to your project. However, you probably won't want this `README.md`.
2. You may want to rename the `cli.sh` script, or leave the name as is, it doesn't matter what the name is, as long as any references in the `docs` and `tests` directory are also updated.
3. Consider adding something like the following section to your own `README.md`
  ```markdown
  To install the CLI, create a symlink: `ln -s cli.sh /usr/bin/cli`
  ```
