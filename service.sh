#!/bin/bash

source ./config.sh

COMMANDS=(
	'start'
	'stop'
	'restart'
	'status'
	'build'
	'create-service'
	'backup'
)

PARAMS=(); # 0 - name; 1 - path; 2 - port;

project_check(){
	for project in "${PROJECTS[@]}"; do
		for param in ${project// / }; do
			PARAMS+=("$param");
		done

		if [[ ${PARAMS[0]} == $1 ]]; then
			echo 'true';
			exit 0;
		fi
	done
}



while getopts p:c: name; do
	case $name in
	 	p)
	    	if [[ $(project_check $OPTARG) == 'true' ]]; then
	    		echo "asd";
	    		echo $PARAMS;
	    		echo $COMMANDS;
	    	else
	    		echo "Error: project name";
	    	fi
	    ;;
	  	\?)
	    	echo "Invalid option: -$OPTARG" >&2
	    	exit 1
	    ;;
	  	:)
	    	echo "Option -$OPTARG requires an argument." >&2
	    	exit 1
	  	;;
		esac
done


#./service.sh -p atlantida -c status