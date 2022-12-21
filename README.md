# Emacs VHDL Formatter

Format your VHDL code using emacs.

## How it works

Basically, we call emacs in batch mode, hand in the content of the VHDL file
over stdin and retrieve the formatted code over stdout[.](..md)

### Custom settings

The `emacs-vhdl-formatter.customEval` option allows you to extend the evaluated
elisp code. This feature allows you to customize the VHDL style before you
format the code. In most cases you want to adjust the `vhdl-offsets-alist` which
defines the indentation for various components. Per default this list contains

```lisp
((string . -1000)                                -- inside multi-line string
 (block-open . 0)                                -- statement block open
 (block-close . 0)                               -- statement block close
 (statement . 0)                                 -- a VHDL statement
 (statement-cont . vhdl-lineup-statement-cont)   -- a continuation of a VHDL statement
 (statement-block-intro . +)                     -- the first line in a new statement block
 (statement-case-intro . +)                      -- the first line in a case alternative block
 (case-alternative . +)                          -- a case statement alternative clause
 (comment . vhdl-lineup-comment)                 -- a line containing only a comment
 (arglist-intro . +)                             -- the first line in an argument list
 (arglist-cont . 0)                              -- subsequent argument list lines when no
                                                    arguments follow on the same line as
                                                    the arglist opening paren
 (arglist-cont-nonempty . vhdl-lineup-arglist)   -- subsequent argument list lines when at
                                                    least one argument follows on the same
                                                    line as the arglist opening paren
 (arglist-close . vhdl-lineup-arglist)           -- the solo close paren of an argument list
 (entity . 0)                                    -- inside an entity declaration
 (configuration . 0)                             -- inside a configuration declaration
 (package . 0)                                   -- inside a package declaration
 (architecture . 0)                              -- inside an architecture body
 (package-body . 0)                              -- inside a package body
 (context . 0))                                  -- inside a context declaration
```

Use `vhdl-set-offset` function to change values in `vhdl-offsets-alist`. For
example to remove the indentation on closing brackets set
`emacs-vhdl-formatter.customEval` to

```lisp
(vhdl-set-offset 'arglist-close 0)
```

## Requirements

This plugin requires you to have [Emacs](https://www.gnu.org/software/emacs/)
installed and available in your path.

### Windows users

We recommend Windows users to install emacs in a wsl and then call emacs within
that wsl. Currently, this is the default configuration for Windows users.
However, if you manage to do it otherwise, feel free to do so.

## Extension Settings

This extension contributes the following settings:

- `emacs-vhdl-formatter.executable.unix`: Emacs executable on Unix based
  systems. Defaults to `emacs`.
- `emacs-vhdl-formatter.executable.windows`: Emacs executable on Windows.
  Defaults to `wsl` to run emacs inside the wsl.
- `emacs-vhdl-formatter.extraArgs.windows`: Additional arguments on Windows
  separated by spaces. Defaults to `emacs` as an argument to wsl.
- `emacs-vhdl-formatter.customEval`: Custom elisp code which gets executed
  before the document is formatted. Defaults to `(vhdl-set-style \"IEEE\")`.

## Release Notes

### 1.0.0

Initial release

### 1.0.1

Use the MIT license
