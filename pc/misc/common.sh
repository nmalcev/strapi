function config {
	bash -c "podman-compose $1 config"
}

function up {
	sh -c "podman-compose $1 down --remove-orphans"
	sh -c "podman-compose $1 up --build -d"
}

function down {
	sh -c "docker-compose $1 down"
}


function connect {
	local LIST=$(podman ps -f status=running --format '{{.Names}}')
	local i=1
	for N in $LIST; do
		echo "$i. $N"
		let 'i=i+1' 
	done
	read -p "Enter the number: " linenumber  
	echo $linenumber
	i=1
	for container_name in $LIST; do
		if [[ "$i" == "$linenumber" ]]; then
			break
		fi
		let 'i=i+1' 
	done

	echo "Attaching to the container $container_name"
	podman exec -it $container_name sh
}

function help {
	echo """Commands:
'manage.sh help' - to see this help	
'manage.sh connect'
"""
}
