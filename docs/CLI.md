# CLI

## Declaring a new command

Create a new `.sh` script in the `commands` directory, the name of the script is the name of the command.

Running `cli.sh` or `cli.sh list` will then show the newly created command.

When running `cli.sh` followed by the name of the command, the shell script for the command will be sourced as is. This means that commands do not need to use any specific functions to run.

## Providing a description and help information

In the `commands` directory, create a file using the same name as the command, with the suffix of `.help.txt`.

For example, if the name of the command is `hello-world` you would have `hello-world.sh` and `hello-world.help.txt`.

The first line of the `.help.txt` file is used as the description that appears next to the command when running `cli.sh` or `cli.sh list`.

The full contents of the `.help.txt` file are then used when running `cli.sh help` followed by the name of the command.

Using the same `hello-world` example, running `cli.sh help hello-world` would result in the contents of `hello-world.help.txt` being printed.

## Useful variables and functions which command scripts can use

* `$CMD` is the name of the command being run, all positional arguments have been shifted, so `$1` is not the name of the command, instead it is the first argument passed after the name of the command. Checking if `$#` is `0` is a quick way to know if the user provided any additional arguments.
* The function `command_exists` will check if a given command exists, for example `command_exists "hello-world"` will return `0` if `hello-world` is a command, otherwise `1`.
* To print error, warning and success messages, the functions `error`, `warning` and `success` are provided, all arguments passed to these will be printed.
* Some formatting variables are provided which can be used to format output: `${RESET}` `${RED}` `${GREEN}` `${YELLOW}` `${BLUE}`
