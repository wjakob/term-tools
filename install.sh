#!/bin/bash
echo "$0: TERM-TOOLS INSTALLER"
echo ""

# if -f, make sure it is intended
for f in $@; do
	if [ "$f" == "-f" ]; then
		echo "Note: -f was provided as an argument, which may overwrite any existing configuration"
		read -r -p "Are you sure? [y/N] " response
		case $response in
			[yY][eE][sS]|[yY])
				:
				;;
			*)
				exit 1
				;;
		esac
	else
		echo "Error: unknown argument: $f"
		exit 1
	fi
done

# trap errors
function print_err() {
	echo "ERROR: install incomplete"
}
trap print_err ERR

set -e

git pull
git submodule init
git submodule update

# run through the installers
for f in $(ls -1 installers/*.sh); do
	inst="y"
	read -r -p "Install config for $(basename $f .sh)? [Y/n] " response
	if [ -z "$response" ] || [[ $response =~ ^[Yy]$ ]] ;  then
		if bash $f $@; then
			echo "SUCCESS: $f"
		else
			echo "ERROR: $f"
			exit 1
		fi
	else
		echo "SKIPPING: $f"
	fi
done

set +x
echo ""
echo " == INSTALL COMPLETE =="
echo ""
echo "To overwrite existing config, rerun with -f (this will delete any existing configuration)"
echo ""
echo "Add this line to both your ~/.bashrc and ~/.zshrc:"
echo "    [[ -s ~/term-tools/config/shrc.sh ]] && source ~/term-tools/config/shrc.sh"
echo ""
echo "To make zsh the default shell, run:"
echo "    chsh -s /bin/zsh"
echo "and then restart the terminal (or re-login for Ubuntu)"
echo ""
echo " ======================"
