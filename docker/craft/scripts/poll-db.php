<?php
// usage php poll-db.php 
// read paramters from environment variables

function getConnection(){
	// 	get the parameters
		$environment = getenv("ENVIRONMENT");
	$db_type  = getenv("DB_DRIVER");
	$server   = getenv("DB_SERVER");
	$database = getenv("DB_DATABASE");
	$username = getenv("DB_USER");
	$password = getenv("DB_PASSWORD");
	
	$dbUri = "$db_type://$server/$database;user=$username;password=*****  ... ";
	// 	TODO handle postgres
			// 	if($db_type == 'pgsql'){
		// 		$schema = getenv("DB_SCHEMA");
		//}		echo "testing connection [$environment]: $dbUri";
		
		// 		test connection
		$dbConnection = false;
		if($db_type == "mysql") {
			$dbConnection = @mysqli_connect($server, $username, $password);
		}
		// 		TODO add postgres configuration
		
		return $dbConnection;
	}
	
	if (getConnection() === false) {
		exit(1);
	}
	exit(0);
	?>