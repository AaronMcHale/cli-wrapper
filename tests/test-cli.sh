#!/usr/bin/env bash
set -eu

# Cd to the directory of this script
cd "${0%/*}"

# Test variables
TEST_CMD="test-$(( RANDOM % 900000 + 100000 ))"
TEST_CMD_PATH="commands/$TEST_CMD.sh"
HELP_TXT_PATH="commands/$TEST_CMD.help.txt"

PROJECT_ROOT="$(dirname "$(dirname "$(realpath "$0")")")"
cleanup() {
  rm "$PROJECT_ROOT/$TEST_CMD_PATH" || true
  rm "$PROJECT_ROOT/$HELP_TXT_PATH" || true
  rm "$PROJECT_ROOT/tests/cli-symlink.sh" || true
}
trap cleanup EXIT

# Create test command script
echo "Create test command at $TEST_CMD_PATH..."
echo 'echo "Test command executed"' > "../$TEST_CMD_PATH"
echo "OK"
echo

# Run tests

echo "Testing cli.sh output for our test command..."
cd ..
OUT=$(./cli.sh)
if [[ "$OUT" != *"$TEST_CMD"* ]]; then
  echo "FAIL: Test command $TEST_CMD not found in cli.sh output"
  exit 1
fi
echo "OK"
echo

echo "Testing running cli.sh from tests directory, to proove that it can be run from anywhere..."
cd tests
OUT=$(./../cli.sh)
if [[ "$OUT" != *"$TEST_CMD"* ]]; then
  echo "FAIL: Test command $TEST_CMD not found when running from tests dir"
  exit 1
fi
cd ..
echo "OK"
echo

echo "Testing cli.sh as a symlink from tests directory, to proove that it can be run as a symlink from anywhere..."
cd tests
ln -s ../cli.sh ./cli-symlink.sh
OUT=$(./cli-symlink.sh)
if [[ "$OUT" != *"$TEST_CMD"* ]]; then
  echo "FAIL: Test command $TEST_CMD not found when running cli.sh as a symlink from tests dir"
  exit 1
fi
cd ..
echo "OK"
echo

echo "Testing cli.sh list sub-command to check output..."
OUT=$(./cli.sh list)
if [[ "$OUT" != *"$TEST_CMD"* ]]; then
  echo "FAIL: Test command $TEST_CMD not found in cli.sh list output"
  exit 1
fi
echo "OK"
echo

echo "Create $HELP_TXT_PATH file for test command..."
echo "this is a test command" > "$HELP_TXT_PATH"
OUT=$(./cli.sh list)
if [[ "$OUT" != *"this is a test command"* ]]; then
  echo "FAIL: $HELP_TXT_PATH content not found in cli.sh list output"
  exit 1
fi
echo "OK"
echo

echo "Test that a second line in the help file does not show on command list..."
echo "this line should not show on the command list" >> "$HELP_TXT_PATH"
OUT=$(./cli.sh list)
if [[ "$OUT" = *"this line should not show on the command list"* ]]; then
  echo "FAIL: $HELP_TXT_PATH content not found in cli.sh list output"
  exit 1
fi
echo "OK"
echo

echo "But that it does show when running help $TEST_CMD..."
OUT=$(./cli.sh help $TEST_CMD)
if [[ "$OUT" != *"this line should not show on the command list"* ]]; then
  echo "FAIL: $HELP_TXT_PATH content not found in cli.sh list output"
  exit 1
fi
echo "OK"
echo

echo "Testing cli.sh help $TEST_CMD to check output..."
OUT=$(./cli.sh help $TEST_CMD)
if [[ "$OUT" != *"this is a test command"* ]]; then
  echo "FAIL: cli.sh help did not show $HELP_TXT_PATH content"
  exit 1
fi
echo "OK"
echo

echo "All tests passed!"
