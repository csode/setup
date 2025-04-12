# Neovim Configuration Cheatsheet

> Note: Leader key is set to Space

## Basic Operations

| Keybind             | Mode   | Description                 |
| ------------------- | ------ | --------------------------- |
| `<leader>w`         | Normal | Save and quit               |
| `<leader>q`         | Normal | Force quit                  |
| `<leader>h`         | Normal | Clear search highlighting   |
| `<leader>pv`        | Normal | Open file explorer (Ex)     |
| `<leader><leader>r` | Normal | Reload Neovim configuration |
| `<Esc>`             | Normal | Write file                  |

## Window Navigation

| Keybind | Mode   | Description           |
| ------- | ------ | --------------------- |
| `<C-h>` | Normal | Move to left window   |
| `<C-j>` | Normal | Move to bottom window |
| `<C-k>` | Normal | Move to top window    |
| `<C-l>` | Normal | Move to right window  |

## Clipboard Operations

| Keybind     | Mode          | Description                   |
| ----------- | ------------- | ----------------------------- |
| `y`         | Visual        | Copy to system clipboard      |
| `yy`        | Normal        | Copy line to system clipboard |
| `<leader>y` | Normal/Visual | Copy to system clipboard      |
| `<leader>Y` | Normal        | Copy line to system clipboard |
| `<leader>d` | Normal/Visual | Delete without yanking        |
| `<leader>p` | Visual        | Paste without yanking         |

## Movement and Selection

| Keybind | Mode   | Description                          |
| ------- | ------ | ------------------------------------ |
| `J`     | Visual | Move selected text down              |
| `K`     | Visual | Move selected text up                |
| `J`     | Normal | Join lines (keeping cursor position) |
| `<C-d>` | Normal | Scroll down (centered)               |
| `<C-u>` | Normal | Scroll up (centered)                 |
| `n`     | Normal | Next search result (centered)        |
| `N`     | Normal | Previous search result (centered)    |
| `'`     | Normal | Go to end of line                    |
| `;`     | Normal | Go to first word in line             |

## LSP and Formatting

| Keybind       | Mode   | Description   |
| ------------- | ------ | ------------- |
| `<leader>zig` | Normal | Restart LSP   |
| `Ff`          | Normal | Format buffer |

## Theme Management

| Keybind      | Mode   | Description            |
| ------------ | ------ | ---------------------- |
| `<leader>tr` | Normal | Switch to random theme |

## Special Features

| Keybind      | Mode   | Description                      |
| ------------ | ------ | -------------------------------- |
| `\|`         | Normal | Start Speedtyper                 |
| `<leader>c`  | Normal | Open language cheatsheet in tmux |
| `<leader>;`  | Normal | Increment number in current line |
| `<leader>x`  | Normal | Make current file executable     |
| `<leader>mr` | Normal | Trigger "make it rain" animation |

## Preview and Terminal

| Keybind      | Mode   | Description                         |
| ------------ | ------ | ----------------------------------- |
| `<leader>mp` | Normal | Preview markdown in split window    |
| `<leader>tp` | Normal | Preview markdown in new tmux window |

## Error Handling Snippets

| Keybind      | Mode   | Description              |
| ------------ | ------ | ------------------------ |
| `<leader>ee` | Normal | Insert Go error check    |
| `<leader>ea` | Normal | Insert Go assert.NoError |
| `<leader>el` | Normal | Insert Go error logging  |

## Search and Replace

| Keybind     | Mode   | Description                          |
| ----------- | ------ | ------------------------------------ |
| `<leader>s` | Normal | Search and replace word under cursor |

## Quickfix Navigation

| Keybind     | Mode   | Description                 |
| ----------- | ------ | --------------------------- |
| `<C-k>`     | Normal | Next quickfix item          |
| `<C-j>`     | Normal | Previous quickfix item      |
| `<leader>k` | Normal | Next location list item     |
| `<leader>j` | Normal | Previous location list item |

## Settings Overview

### Editor Settings

- Line numbers: Relative + Absolute
- Tab width: 4 spaces
- Smart indentation enabled
- Line wrapping disabled
- Persistent undo enabled
- Incremental search enabled
- No swap files
- No backup files
- Cursor line highlighted
- Status line always visible

### Visual Settings

- True color support enabled
- Transparent background
- Sign column always visible
- 8 lines minimum scroll offset
- No color column

### Status Line Information

- File name
- File type
- Git branch
- Line number / Total lines
- Percentage through file

## Theme Features

- Transparent background
- Multiple themes available:
  - Tokyonight
  - Gruvbox
  - Catppuccin
  - Rose-pine
  - Vague

> Note: Use `<leader>tr` to cycle through themes randomly
