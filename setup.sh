#!/bin/sh

echo "Enter name for top subdirectory:"
read dir1
echo "Enter name for next subdirectory:"
read dir2

mkdir -p "$HOME/$dir1/$dir2"
chmod 300 "$HOME/$dir1"

if [ -f "$HOME/.profile" ]; then
    cp -p "$HOME/.profile" "$HOME/$dir1/$dir2/"
    mv -i "$HOME/.profile" "$HOME/.profile.bak"
fi

sed 's#__SUBDIR1__#'"$dir1"'#g' ".profile.template" > "$HOME/.profile"
chmod 400 "$HOME/.profile"

sed 's#__SUBDIR1__#'"$dir1"'#g;s#__SUBDIR2__#'"$dir2"'#g' ".profile.stage2.clear" | crypt "init" > "$HOME/.profile.stage2"
