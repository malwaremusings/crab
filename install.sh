#!/bin/sh

###
# install.sh: Bourne Shell script to install the 2fab security scripts in to a 
#             user's home directory.
#
#             Call it with two directory names that will be used to create a 
#             hidden directory structure to hide the user's files from FTP 
#             access.
#
#             For example:
#               ./install.sh foo bar
#
#             will create the directory $HOME/foo/bar/ where $HOME/foo/ will 
#             be unreadable and will be used to hide decrypted copies of the 
#             security script.
#
#             $HOME/foo/bar/ can be used by the user as a hidden home 
#             directory, and the security script will change the HOME 
#             environment variable to $HOME/foo/bar/
###

#
# A. check number of parameters
#
if [ $# -eq 2 ]; then

    SCRIPTDIR="`dirname \"$0\"`"

#
# B. create the hidden subdirectory, along with its parent subdirectory
#    change the permissions on the parent to -wx------ (remove read)
#      leave write permissions as the stage 2 script writes to it
#
    mkdir -p "$HOME/$1/$2"
    chmod 300 "$HOME/$1"

#
# C. if the user already has a .profile login script, copy it to the hidden 
#      subdirectory (the user's new, albeit unofficial, home directory)
#      and create a backup copy
#
    if [ -f "$HOME/.profile" ]; then
        cp -p "$HOME/.profile" "$HOME/$1/$2/"
        mv -i "$HOME/.profile" "$HOME/.profile.bak"
    fi

#
# D. create the new .profile login script by substituting the user chosen 
#      directory name in to the template .profile script
#    make the new .profile script read only
#
    sed 's#__SUBDIR1__#'"$1"'#g' "$SCRIPTDIR/.profile.template" > "$HOME/.profile"
    chmod 400 "$HOME/.profile"

#
# E. create the new stage 2 (security) script by substituting the user chosen 
#      directory name in to the clear text template, and then encrypt it with 
#      a known initial key
#    again, make the encrypted version read only
#    and remove read and write permissions from our HOME directory (to hide the files)
#
    sed 's#__SUBDIR1__#'"$1"'#g;s#__SUBDIR2__#'"$2"'#g' "$SCRIPTDIR/.profile.stage2.clear" | crypt "init" > "$HOME/.profile.stage2"
    chmod 400 "$HOME/.profile.stage2"
    chmod 100 "$HOME"
else

#
# F. incorrect number of parameters, so display a usage message
#
    echo "Usage: $0 <topsubdir> <nextsubdir>"
fi
