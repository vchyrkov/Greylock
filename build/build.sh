#!/bin/bash
#
# http://google-styleguide.googlecode.com/svn/trunk/shell.xml

readonly CWD=$(cd $(dirname $0); pwd)
readonly GLIZE_REPO="git@github.com:Datamart/Glize.git"
readonly GLIZE_PATH="${CWD}/../glize"
readonly GLIZE_COPY="${CWD}/../src/glize"

#
# Prints message.
# Arguments:
#   message - The message text to print.
#
function println() {
  printf "%s %0$(expr 80 - ${#1})s\n" "$1" | tr "0" "-"
}

#
# The sync submodule.
#
function submodule() {
  println "[SYNC] ${GLIZE_PATH}:"
  if [ -d "$GLIZE_PATH" ]; then
    git rm -r --force --cached ${GLIZE_PATH}
  fi

  cd "${CWD}/../"
  git submodule add --force ${GLIZE_REPO} "glize"
  git submodule update --init --recursive

  rm -rf "${GLIZE_COPY}"
  mkdir  "${GLIZE_COPY}"
  cp -r "${GLIZE_PATH}/src" "${GLIZE_COPY}"
  cd "${CWD}"
}

#
# The main function.
#
function main() {
  submodule

  println "[WEB] Running linter:"
  chmod +x jslint.sh && ./jslint.sh

  println "[WEB] Running compiler:"
  chmod +x jsmin.sh && ./jsmin.sh

  println "[WEB] Done"
}

main "$@"
