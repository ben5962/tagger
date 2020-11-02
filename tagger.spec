# afin de trier entre les fichiers à sauver et les autres non,
# 1) je veux tagger tous les fichiers d un rep et du sous rep comme "untagged"
# 2) puis les tagger tous entre "asauver" et "adropper" en decision finale et verifier que tous les fichiers du rep de départ sont bien d un coté ou de l autre de la categ.
# 
# afinn de faire cela, appres avoir taggué tousl es fichires comme "untagged"
# 3) je veux ensuite pouvoir ajouter des tags à certains fichiers. l ajout d un 2eme tag supprime le tag "untagged"
# 4) je veux afficher pour un tag donné la liste des fichiers  ayant ce tag afin d effectuer ma sauvegarde. 
# -> les tags supp pourraient aider à savoir ou faire la sauvegarde
# 5)  je veux pouvoir pour un fichier donné afficher la liste des tags pour verif



# soit un fichier.
find "$1" -type f -exec 'ln --symbolic "untagged-{}"'
ln --
get_conf_file(){
local readonly conf_file="~/.tagger"
echo "$conf_file"
}

get_tag_initial(){
local readonly tag_initial="untagged"
echo "$tag_initial"
}



init(){
set_racine "$racine"
find "$racine" -type f -exec tag {} 
}

set_racine(){
local racine="$1"
echo "$racine" > $(get_confile)
}

lien(){
[ $# -ne 2 ] && echo "lien vers depuis" && return 1;
vers="$1"
depuis="$2"
ln --symbolic $vers $depuis
}
