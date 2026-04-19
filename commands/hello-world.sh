#!/usr/bin/env bash
echo "Hello world!"

# Examples of using the helper functions to print messages.

# You can cd to the directory of the cli script using `$CLIROOT`
cd "$CLIROOT"
# You can also cd to the commands directory using `$CMDROOT`
cd "$CMDROOT"

# You can check if a command exists and do something
command_exists "hello-world" && echo "hello world exists!"

# This will print a formatted warning message with the text
# "this is a warning".
warning "this is a warning"

# This will print a formatted error message with the text
# "this is an error!".
error this is a error message!
# If we want to exit after an error, we still have to call exit.
# Also notice that we did not quote the message passed to error
# as the helper functions will read all arguments and print them
# so quotes aren't needed.

# This will print a formatted success message with the text
# "yay!"
success yay!
