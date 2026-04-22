#!/bin/sh
TASKFILE="/home/ltlnx/Documents/Notes/tools/tasks.txt"
DOCFILE="/home/ltlnx/Documents/Notes/tasks.md"
MAKEDOC="1"
test "$1" = "count" && { wc -l <$TASKFILE; exit 0; }
print_help() {
    printf "${0##*/}: ltlnx's personal task manager.
Usage: ${0##*/} OPTION [ARGUMENTS]...

Environment variables:
  TASKFILE    determines where the task file (tasks.txt) is stored
  DOCFILE     where the rendered Markdown document (tasks.md) by
              \`tasks makedoc\` should be stored. 
  MAKEDOC     whether to render the Markdown document every time the
              task list is modified. Unset the variable
              (\`MAKEDOC=\"\"\`) to disable.
  Please modify the variables in the script to your needs.

Options:
  (no args)   lists all the tasks with task numbers.
  add DESC    add a task.
              e.g. \`tasks add \"code: write documentation\"\`
              Supports \"after\" as an argument; used as the following:
              e.g. to add a task after task no. 4:
              \`tasks add after 4 \"code: write documentation\"\`
  pop NUM     remove a task; please supplement the task number as specified
              by \"tasks\" (with no arguments).
              e.g. \`tasks pop 4\`
  done NUM    toggles a tasks's \"done\" status by adding or removing
              \"[done]\" in front of the task. As with \`pop\`, takes a
              number as the argument.
  clear       clear all tasks. This moves the original task file into
              \$TASKFILE.bak and initializes a new one.
  count       returns the task count. Useful to add to e.g. your bashrc.
  makedoc     renders the task list into a markdown file saved at \$DOCFILE.

Ask questions, report bugs and send patches to ltlnx dot tw at gmail dot com.
"
}
die() {
    echo "$1" && exit 1
}
makedoc() {
    cat "$TASKFILE" | grep -o "^[^:]*:" | grep -v "^\[done\]" | \
        sort | uniq | while read group; do
        echo "### $(echo $group | grep -o "^[^:]*" | sed 's|\b\(.\)|\u\1|g')"
        cat "$TASKFILE" | grep "$group" | sed "s/^\[done\] [^:]*: /- [x] /g;s/^[^:]*: /- [ ] /g"
    done > $DOCFILE
    if (cat "$TASKFILE" | grep -q -v "^[^:]*:"); then
        echo "### No Category"
        cat "$TASKFILE" | grep -v "^[^:]*:" | sed "s/^/- [ ] /g;s/^- \[ \] \[done\]/- [x] /g"
    fi >> $DOCFILE
}
case $1 in
    help)
        print_help
        exit 0
        ;;
    add)
        if (test "$2" = "after"); then
            echo "$3" | grep -q "^[0-9]$" || die "Please input a number"
            test "$4" || die "Please enter something to add"
            test "$5" && die "Please put the sentence in double quotes"
            contents=$(sed "$(expr $3 + 1)s|^|$4\n|" <"$TASKFILE")
            echo -e "$contents" > "$TASKFILE"
        else
            test "$2" || die "Please enter something to add"
            test "$3" && die "Please put the sentence in double quotes"
            echo "$2" >> "$TASKFILE"
        fi
        test "$MAKEDOC" = "1" && makedoc
        ;;
    pop)
        echo "$2" | grep -q "^[0-9]*$" || die "Please input a number" 
        contents=$(sed "${2}d" <"$TASKFILE")
        test "$contents" && echo -e "$contents" > "$TASKFILE" || printf "" > "$TASKFILE"
        test "$MAKEDOC" = "1" && makedoc
        ;;
    done)
        echo "$2" | grep -q "^[0-9]*$" || die "Please input a number" 
        if (cat "$TASKFILE" | sed "${2}q" | grep "\[done\]"); then
            contents=$(cat "$TASKFILE" | sed "${2}s/^\[done\] //")
        else
            contents=$(cat "$TASKFILE" | sed "${2}s/^/[done] /")
        fi
        test "$contents" && echo -e "$contents" > "$TASKFILE" || printf "" > "$TASKFILE"
        test "$MAKEDOC" = "1" && makedoc
        ;;
    sort)
        contents=$(cat "$TASKFILE" | sort)
        test "$contents" && echo -e "$contents" > "$TASKFILE" || printf "" > "$TASKFILE"
        ;;
    clear)
        mv $TASKFILE $TASKFILE.bak && touch $TASKFILE
        test "$MAKEDOC" = "1" && makedoc
        ;;
    makedoc)
        makedoc
        ;;
    *)
        test "$1" && die "Not implemented"
        ;;
esac
nl -w2 -s': ' $TASKFILE
