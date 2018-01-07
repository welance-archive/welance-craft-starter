<?php
// usage php poll-db.php 
// read paramters from environment variables

// get the parameters
$environment = getenv("CRAFT_ENVIRONMENT");
$db_type  = getenv("DB_DRIVER");
$server   = getenv("DB_HOST");
$database = getenv("DB_NAME");
$username = getenv("DB_USER");
$password = getenv("DB_PASS");

$dbUri = "$db_type://$server/$database;user=$username;password=*****  ... ";
// TODO handle postgres
// if($db_type == 'pgsql'){
	// 	$schema = getenv("DB_SCHEMA");
	//}	echo "testing connection [$environment]: $dbUri";
	
	// 	test connection
	$dbConnection = false;
	if($db_type == "mysql") {
		$dbConnection = @mysqli_connect($server, $username, $password);
	}
	// 	TODO add postgres configuration
	
	if (!$dbConnection) {
		exit(1);
		// 		connection failed
	}
	exit(0);
	// 	connection ok
	?>