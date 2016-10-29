PROJECTS=();
PROJECTS+=("altme-2990 2990 /data/meteors/altmeSystem null");

for project in $(node /data/git/bash/control-meteor-project/get_array_project.js); do
	LINE=$(echo $project | tr "|" " ");
	PROJECTS+=("$LINE");
done