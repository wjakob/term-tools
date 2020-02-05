term-tools
==========

Wenzel's terminal setup. Contains nice default settings for

* vim
* tmux
* zsh
* git
* octave
* xterm
* karabiner (OSX)

How to install
--------------

* Clone this repository and run the installer:
```
git clone https://github.com/wjakob/term-tools.git ~/.term-tools
cd ~/.term-tools
./install.sh
```

* Install the font ``config/ubuntu_mono_patched.zip`` on your
  system and and configure your terminal to use it


Overview of various shortcuts
-----------------------------
```
Tabs
----
Alt + T              TMUX: make new tab
Alt + []             TMUX: switch to prev/next tab
[]                   VIM:  switch to prev/next tab

Basics
------
Shift + Alt + JK     TMUX: scroll up/down
Ctrl + HJKL          PgUp/PgDown/Home/End
Ctrl + Backspace     Delete
Ctrl + JK            Navigate through zsh history

Splits/Panes
------------
Alt + ,              VIM & TMUX: Split (-)
Alt + .              VIM & TMUX: Split (|)
Alt + HJKL           VIM & TMUX: switch to different pane/split
Alt + Q              VIM & TMUX: close pane/split
Alt + F              VIM & TMUX: maximize pane/split

FZF
----
Alt + D              Jump to directory
Alt + P              Paste filename
Alt + R              Search history
Ctrl + JK            Navigate through search results
Shift + Alt + JK     TMUX: move through scroll buffer


VIM Normal mode
---------------

<space>              Toggle folds
<enter>              Clear search results (press enter twice after search)
Q                    Justify selection/paragraph to 80 cols
: ;                  ':' and ';' are swapped (saves a 'shift' key on very common operations)
Ctrl + Space         Open context completion
Ctrl + JK            Navigate through context completion
Alt + P              Open a file using FZF

<leader>m            Launch a compilation job (using 'ninja')
:ag [keywords]       Search for a file using 'ag'


VIM C++ integration
-------------------

D                    Jump to definition
R                    Find all references
<leader>l            Format selected code using 'clang-format'


VIM Git integration
-------------------
<leader>j            Jump to next modified hunk
<leader>k            Jump to previous modified hunk
<leader>K            Jump to first modified hunk
<leader>J            Jump to last modified hunk
<leader>gs           GIT status
-                    Toggle files to be committed in GIT status
<leader>gr           GIT read from index  (aka. git co ..)
<leader>gw           GIT write from index (aka. git add)
<leader>gc           GIT commit with message
<leader>gd           GIT diff
dp                   Diff put (in 2/3-way split)
do                   Diff get ("obtain")
```
