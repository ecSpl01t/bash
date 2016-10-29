PROJECTS=();

for project in $(node get_array_project.js); do
	LINE=$(echo $project | tr "|" " ");
	PROJECTS+=("$LINE");
done