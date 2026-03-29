# CLI

## Declaring a new command

Create a new `.sh` script in the `commands` directory, the name of the script is the name of the command.

Note that these scripts do not need to be executable, they only need to end in `.sh`.

Running `cli.sh` or `cli.sh list` will then show the newly created command.

When running `cli.sh` followed by the name of the command, the shell script for the command will be sourced as is. This means that commands do not need to use any specific functions to run.

## Writing the command script

The command script in the `commands` directory will be sourced by the top-level `cli.sh` script when the command is run, this means that the script should be written procedurally.

Scripts should be written following these best practices:
* Start with `#!/usr/bin/env bash`
* Do not write any usage or help functions within the script, instead use a `.help.txt` file, see the next section for more details.
* Use `$CMD` to get the name of the command being run. All positional arguments have been shifted, so `$1` is not the name of the command, instead it is the first argument passed after the name of the command. Checking if `$#` is `0` is a quick way to know if the user provided any additional arguments.
* To check if a command exists, use the `command_exists` function, for example `command_exists "hello-world"` will return `0` if `hello-world` is a command, otherwise `1`.
* To print error, warning and success messages, use the functions `error`, `warning` and `success`, all arguments passed to these will be printed.
* Some formatting variables are provided which can be used to format output: `${RESET}` `${RED}` `${GREEN}` `${YELLOW}` `${BLUE}`

## Providing a description and help information

In the `commands` directory, create a file using the same name as the command, with the suffix of `.help.txt`.

For example, if the name of the command is `hello-world` you would have `hello-world.sh` and `hello-world.help.txt`.

The first line of the `.help.txt` file is used as the description that appears next to the command when running `cli.sh` or `cli.sh list`.

The full contents of the `.help.txt` file are then used when running `cli.sh help` followed by the name of the command.

Using the same `hello-world` example, running `cli.sh help hello-world` would result in the contents of `hello-world.help.txt` being printed.
