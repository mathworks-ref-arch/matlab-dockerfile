#!/bin/bash
#
# Copyright 2019 The MathWorks, Inc.

ECHO=echo

#=======================================================================
build_cmd () { # Takes the cmd input string and outputs the same
    # string correctly quoted to be evaluated again.
    #
    # Always returns a 0
    #
    # usage: build_cmd
    #

    # Use version of echo here that will preserve
    # backslashes within $cmd. - g490189

            $ECHO "$1" | awk '
#----------------------------------------------------------------------------
        BEGIN { squote = sprintf ("%c", 39)   # set single quote
                dquote = sprintf ("%c", 34)   # set double quote
              }
          NF != 0 { newarg=dquote             # initialize output string to
                                              # double quote
          lookquote=dquote                    # look for double quote
          oldarg = $0
          while ((i = index (oldarg, lookquote))) {
             newarg = newarg substr (oldarg, 1, i - 1) lookquote
             oldarg = substr (oldarg, i, length (oldarg) - i + 1)
             if (lookquote == dquote)
                lookquote = squote
             else
                lookquote = dquote
             newarg = newarg lookquote
          }
          printf " %s", newarg oldarg lookquote }
#----------------------------------------------------------------------------
        '
            return 0
}

ARGLIST=""

while [ $# -gt 0 ]; do
    case "$1" in
        -r|-batch)
            QUOTED_CMD=`build_cmd "$2"`
            ARGLIST="${ARGLIST} $1 `$ECHO ${QUOTED_CMD}`"
            shift
            ;;
        *)
            ARGLIST="${ARGLIST} $1"
    esac
    shift
done


eval exec "matlab ${ARGLIST}"

exit