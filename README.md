# Miniatur Neovim Config
A fun project but with the ambition to be used for daily driving.

## My ambitions
- Prefer single init.lua over many modules and directories
- Prefer Neovim's builtin features over 3rd party plugins
- Well documented but opinonated.

## Pre-requisites
- Neovim nightly 0.12
- True color terminal (I'm using Ghostty)
- Nerdfont
- Git

# Native vs Plugin
| Feat         | Native  | Plugin  |
|--------------|---------|---------|
| Lsp          |    X    |         |
| Statusline   |    X    |         |
| Completion   |         |    X*   |
| File Exp     |    X    |         |
|----------------------------------|

NOTE:
For completion we use blink.cmp instead. Tried with native auto complete
from lsp, but experience is pretty poor. No fuzzy typing and shit sorting.
Check for notes in comments and try for yourself.

## Mini plugins
- Auto pairs
- Starter screen


