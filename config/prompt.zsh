# Set up a prompt with powerline symbols
POWERLINE_TIME=%D{%H:%M:%S}
POWERLINE_RV=%(?.$FG[028]✔.$FG[009]✘)
POWERLINE_PATH="%~"
POWERLINE_COL1_FG="250"
POWERLINE_COL1_BG="025"
POWERLINE_COL2_FG="250"
POWERLINE_COL3_FG="250"
POWERLINE_COL2_BG="236"
POWERLINE_COL3_BG="237"

PROMPT="
%f$FG[$POWERLINE_COL1_FG]%k$BG[$POWERLINE_COL1_BG] $POWERLINE_PATH %k$FG[$POWERLINE_COL1_BG]"$'\ue0b0'"%f "
RPROMPT="$POWERLINE_GIT_INFO_RIGHT$FG[$POWERLINE_COL2_BG]"$'\ue0b2'"%k$FG[$POWERLINE_COL2_FG]$BG[$POWERLINE_COL2_BG] $POWERLINE_TIME %f$FG[$POWERLINE_COL3_BG]"$'\ue0b2'"%f%k$BG[$POWERLINE_COL3_BG] $POWERLINE_RV %f%k"
