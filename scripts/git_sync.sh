#!/bin/bash
remote_name="$1"
: ${remote_name:="origin"}

git_root="$(cd "$(git rev-parse --show-toplevel)"; pwd)/"
rsync_dest=$(git remote -v | grep "^$remote_name\s.*\(push\)" | awk '{print $2}')

echo "Remote name: $remote_name"
echo "Repo root: $git_root"
echo "Repo dest: $rsync_dest"

rsync -zr --progress --exclude .git "$git_root" "$rsync_dest"
