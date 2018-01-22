<?php
// usage php poll-craft.php 
// check if craft is installed

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
	
function execQuery($mysqli, $query) {
	if ($result = $mysqli->query($query)) {
		return $result;
	}
	return false;
}

$infoTable = getenv("DB_TABLE_PREFIX")."info";
print($infoTable);
$c = getConnection();

// 	check that the info table exists
$r = execQuery($c,"SHOW TABLES LIKE '".$table."'");

if($r !== false && $result->num_rows == 1){
	// 		check that is not emtpy
		$r = execQuery($c,"SELECT COUNT(*) AS num FROM '".$table."'");
	if($r !== false && $r->num > 0) {
		exit(0);
	}
}
exit(1);
	?>