#!/bin/bash
vim_dir=$PWD/vim
bundles_dir=$vim_dir/bundle
prefix="✌"

log(){
  echo -e "[7m${prefix} $1[27m\n";
}

log "Creating vim folders"
mkdir -p $vim_dir/autoload $bundles_dir $vim_dir/sessions $vim_dir/tmp
log "Installing pathogen"
curl -LSso $vim_dir/autoload/pathogen.vim https://tpo.pe/pathogen.vim

log "Installing plugins"

while read -r line; do
  IFS="✈" read -r -a tmp <<< "$line"
  repo="${tmp[0]}"
  do="${tmp[1]}"
  IFS="/" read -r -a tmp2 <<< "$repo"
  repo_dir="${tmp2[1]}"

  log "Downloading $repo"
  git clone https://github.com/$repo $bundles_dir/$repo_dir

  if [[ $do != "null" ]]; then
    log "Executing do for $repo:\n '$do'"
    cd $bundles_dir/$repo_dir
    eval $do
    cd $bundles_dir
    echo ""
  fi
done < <(jq -r 'to_entries[] | "\(.value.repo)✈\(.value.do)"' vim-plugins.json)

# reset to initial directory
cd $vim_dir && cd ..

log "Symlinking .vimrc && .vim"
ln -s $PWD/vimrc ~/.vimrc
ln -s $vim_dir ~/.vim

log "Finished"
