# term-tools

<p align="center">
   <img src="https://github.com/wjakob/term-tools/raw/master/screenshot.png" alt="screenshot" width="400"/>
</p>

Wenzel's terminal setup. Contains nice default settings for

* vim
* tmux
* zsh
* git
* octave
* karabiner
* kitty
* xterm

The VIM configuration enables a few powerful features that I find very useful
for development and writing research papers:

* Code completion & validation for C++
* Code validation & PEP8 checks for Python
* Mathematical symbols in TeX using Unicode

Navigation through through tmux "pane"s and VIM windows works transparently
using the same set of key bindings.

On Linux, this is intended to be used with good old xterm, which blows modern
terminals (Gnome, KDE) out of the water especially when combined with tmux. On
MacOS, use kitty (https://sw.kovidgoyal.net/kitty/). Everything (vim, tmux,
zsh) consistently uses the tomorrow night theme and powerline fonts. If you use
a different terminal, a number of carefully tweaked interactions won't work
anymore--you have been warned :).

The whole setup is optimized to have extremely low latency, both when starting
terminal/zsh/tmux/vim and during normal usage. For instance, the terminal
prompt shows the current repository branch (very quick to determine), but it
does not inspect whether there are changed files, which can easily add a few
hundred milliseconds of latency to each shell interaction when navigating
through complex projects. Over time, I have progressively replaced popular but
very heavy extensions (e.g. oh-my-zsh for ZSH, or YouCompleteMe for VIM) since
they added too much latency.

The keyboard layout in tmux and VIM is optimized around the home row
(HJKL-style navigation) and, e.g., also maps panel navigation and
home/end/pageup/pagedown into Alt+HJKL and Ctrl+HJKL. It soon feels very
natural, and it is no longer necessary to use the right portion of the
keyboard.

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

ZSH
---
<VIM keybinding>     Go to normal/insert mode using escape, 'i', 'v', etc.
/ ?                  Normal mode: forward or reverse search through the command line
n N                  Navigate through search results
V                    Edit the current command line in VIM

VIM Normal mode
---------------
<space>              Toggle folds
<enter>              Clear search results (press enter twice after search)
Q                    Justify selection/paragraph to 80 cols
: ;                  ':' and ';' are swapped (saves a 'shift' key on very
                     common operations)
Ctrl + Space         Open context completion
Ctrl + JK            Navigate through context completion
Alt + P              Open a file using FZF

:ag [keywords]       Search for a file using 'ag'
U                    Undo tree
,,                   Comment the line or visual selection
,m                   Launch a compilation job (using 'ninja')
,a                   Align columns of a table (followed by an alignment character,
                     e.g. '=' or '2=' for the second occurrence)
,t                   SyncTeX: highlight the selected line in Skim.app.


VIM C++ semantic integration
----------------------------

D                    Jump to definition
R                    Find all references
,l                   Format selected code using 'clang-format'

VIM Git integration
-------------------
,k                   Jump to previous modified hunk
,j                   Jump to next modified hunk
,K                   Jump to first modified hunk
,J                   Jump to last modified hunk
,gs                  GIT status
-                    Toggle files to be committed in GIT status
,gr                  GIT read from index  (aka. git co ..)
,gw                  GIT write from index (aka. git add)
,gc                  GIT commit with message
,gd                  GIT diff
dp                   Diff put (in 2/3-way split)
do                   Diff get ("obtain")
```

Miscellaneous features
----------------------

When running a SSH session, tmux will forward pane/window navigation key
bindings to the remote that is also presumed to run tmux. Prefix Ctrl-A to
execute them locally.
