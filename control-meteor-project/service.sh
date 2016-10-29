#!/bin/bash
#sed -i "/<startVersion>.*<\/startVersion>/{s/>.*</>$PAR_TAG_NAME</;}" $PAR_PATH/$XMLFILE
#sed "/{.*}/{s/PATH/TEst/;}" /etc/systemd/system/test.service
#./service.sh -p atlantida-ua -c status
#./service.sh -s create-service -a nameProject:Path:Port
#sed "/PATH/{s/PATH/TEst/;}" /etc/systemd/system/test.service
#-n PRODUCTION=true;


source /data/git/bash/control-meteor-project/config.sh

DATE=`date +%Y-%m-%d-%H:%M:%S`
FOLDER_SERVICE="/etc/systemd/system";
SUD="sudo";
SERVICE=false;
PRODUCTION=false;

set +H

message(){
	case $1 in
		info)
			echo "[INFO] --$DATE-- $2";
		;;
		error)
			echo "[ERROR]--$DATE-- $2";
		;;
		run)
			echo "[RUN]  --$DATE-- $2";
		;;
	esac
}

COMMANDS=(
	'start'
	'stop'
	'restart'
	'status'
	'build'
	'create-service'
	'backup'
	'cat-service'
	'console'
	'reload'
)

PARAMS=(); # 0 - name; 1 - path; 2 - port;
P_NAME=null;
P_PORT=null;
P_PATHM=null;
P_PATHN=null;

project_check(){
	for project in "${PROJECTS[@]}"; do
		local array=();
		for param in ${project// / }; do
			array+=("$param");
		done
		if [[ ${array[0]} == $1 && $2 == 'check' ]]; then
			echo 'true';
			exit 0;
		elif [[ ${array[0]} == $1 && $2 == 'get' ]]; then
			PARAMS=("${array[@]}");
			if [[ $PRODUCTION == true ]]; then
				P_NAME="${array[0]}-p";
			else
				P_NAME=${array[0]};
			fi
			P_PORT=${array[1]};
			P_PATHM=${array[2]};
			P_PATHN=${array[3]};
		fi
	done
}

command_check(){
	for command in "${COMMANDS[@]}"; do
		if [[ $1 == $command ]]; then
			echo 'true';
			exit 0;
		fi
	done
}

service_create(){
	local params=$1;
	local array=();
	for param in $(echo $params | tr ":" "\n"); do
		array+=("$param");
	done
	message 'info' "Name: ${array[0]}";
	message 'info' "Port: ${array[1]}";
	message 'info' "Path: ${array[2]}";
	local name=${array[0]};
	local port=${array[1]};
	local path=${array[2]};
	
	if ! [[ -e ${FOLDER_SERVICE}/${name}.service ]]; then
		$SUD cp $PWD/skilet.service ${FOLDER_SERVICE}/${name}.service
	fi

	enCode=$(node -e "console.log('${path}'.replace(/\//g,'\\\/'))");

	$SUD sed -i "/{.*}/{s/{PATH}/${enCode}/;}" ${FOLDER_SERVICE}/${name}.service
	$SUD sed -i "/{.*}/{s/{NAME}/${name}/;}" ${FOLDER_SERVICE}/${name}.service
	$SUD sed -i "/{.*}/{s/{PORT}/${port}/;}" ${FOLDER_SERVICE}/${name}.service
	
	sudo systemctl daemon-reload
	cat ${FOLDER_SERVICE}/${name}.service
}

project_command(){
	case $1 in
		create-service)
			message 'info' $1;
			service_create $2;
		;;
		cat-service)
			message 'info' $1;
			message 'run' $1;
			cat $FOLDER_SERVICE/${P_NAME}.service;
		;;
		console)
			message 'info' $1;
			message 'run' $1;
			sudo journalctl -u ${P_NAME}.service -f
		;;
		reload)
			message 'info' 'daemon-reload';
			message 'run' 'daemon-reload';
			sudo systemctl daemon-reload
		;;
		build)
			message 'info' $1;

			if [[ ${P_PATHN} != null ]]; then
				message 'run' $1;
				echo ${PARAMS[@]};
				./meteor_build.sh $P_PATHM $P_PATHN;
			else
				message 'error' $1;
				echo ${PARAMS[@]};
			fi
		;;
		*)
			message 'info' $1;
			message 'run' $1;
			sudo systemctl $1 ${P_NAME}.service
			if [[ $1 == 'start' || $1 == 'stop' ]]; then
				sudo systemctl status ${P_NAME}.service
			fi
		;;
	esac
}

while getopts np:c:s:a: name; do
	case $name in
		n)
			PRODUCTION=true;
		;;
	 	p)
	    	if [[ $(project_check $OPTARG 'check') == 'true' ]]; then
	    		project_check $OPTARG 'get';	    		
	    	else
	    		message 'error' "Project name ($OPTARG)";
	    		exit 0;
	    	fi
	    ;;
	    c)
			if [[ $(command_check $OPTARG) == 'true' ]]; then
				project_command $OPTARG;
			else
				message 'error' "Command false ($OPTARG)";
				exit 0;
			fi
		;;
		s)
			if [[ $(command_check $OPTARG) == 'true' ]]; then
				SERVICE=$OPTARG;
			else
				message 'error' "Command false ($OPTARG)";
				exit 0;
			fi
		;;
		a)
			project_command $SERVICE $OPTARG;
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