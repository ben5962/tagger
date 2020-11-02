#!/bin/bash

#https://www.in-ulm.de/~mascheck/various/find/#embedded
#https://unix.stackexchange.com/questions/476694/recursively-rename-all-the-files-without-changing-their-extensions

is_symb_lnk(){
test -L "$1"
}

export -f is_symb_lnk

_tag_untagged(){
local nom_fichier; nom_fichier=$(basename "$1")
#local tags_dir; tags_dir=$(dirname "$1")/.tags_dir
local tags_dir; tags_dir=$( pwd )/.tags_dir
local cible; cible="$( pwd )/${nom_fichier}"
local depuis; depuis="${tags_dir}/untagged_${nom_fichier}"
echo "depuis vaut: $depuis"
echo "cible vaut $cible"
echo "tags_dir vaut $tags_dir"
echo "pwd vaut $(pwd)"
echo "nom_fichier vaut $nom_fichier"


[ -d "$tags_dir" ] && is_symb_lnk ${depuis} ||  ln --symbolic "${cible}" "${depuis}" 
[ ! -d "$tags_dir" ] && echo "fich $1: _tag_untagged: $tags_dir existe pas. pwd vaut $(pwd)" && exit 1 
is_symb_lnk ${depuis} && echo "le lien symb ${depuis} existe déjà: $(ls $depuis)"
}

export -f _tag_untagged

_mkdir_ine(){
# cree un sous re .tags_dir
# dans chaque dir
# si existe pas
local chemin_repertoire="$1"
local a_creer="$chemin_repertoire/.tags_dir"
[ ! -d "$a_creer" ] && mkdir "$a_creer" && echo "ai cree rep $a_creer"
}
export -f _mkdir_ine


_rm_ie(){
[ -d "$1" ] && rm --recursive "$1"
}

export -f _rm_ie

set_find_all_dirs_not_dottagsdir(){
declare -ar arr_tags_dirs; 
mapfile arr_tags_dirs < <( $(find ~+  -type d ! -path '*.tags_dir*') )
echo "$(arr_tags_dirs[*])"
}

tg_mkdir_all_ine(){
echo "creation des .tags_dir"
find ~+  -type d ! -path '*.tags_dir*' -execdir bash -c '_mkdir_ine $1' bash {} \;
#tag_untagged "pouet"
#find "$(pwd)" -type d ! -path '*.tags_dir*' -execdir mkdir ".tags_dir" \;
#find . -type d  -exec echo "{}/.tags_dir" \;
#ls -ladR  -- */ 
}

tg_tag_all_untagged(){
#find . -type f -exec  ln --symbolic '{}' "$(basename {})/.tags_dir/untagged_{}" \;
echo "creation des tags ds chaque .tags_dir"
find ~+ -type f ! -path '*.tags_dir*' -execdir bash -c '_tag_untagged $1' bash {} \;
ls -lahR
}


reverse(){
echo "nettoyage"
#find . -type d -name .tags_dir -exec rmdir {} \;
find ~+ -type d -name '.tags_dir' -okdir bash -c '_rm_ie $1' bash {} \;
}


trouver_untagged(){
while read lien; do
readlink -f "$lien"
done < <( ( locate untagged ) )

}

#reverse

#reverse #cf refactor
tg_mkdir_all_ine # [ ! -f toujours vrai  devient [ ! -d
tg_tag_all_untagged
