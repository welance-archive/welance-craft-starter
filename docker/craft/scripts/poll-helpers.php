<?php 


function getConnection(){
	
	// 	get the parameters
	$environment = getenv("ENVIRONMENT");
	$dbDriver  = getenv("DB_DRIVER");
	$server   = getenv("DB_SERVER");
	$port = getenv("DB_PORT");
	$database = getenv("DB_DATABASE");
	$dbschema = getenv("DB_SCHEMA");
	$username = getenv("DB_USER");
	$password = getenv("DB_PASSWORD");
	$dbUri = "$dbDriver://$server/$database;user=$username;password=*****  ... ";
	
	
	
	$dbConnection = false;
	if($dbDriver == "mysql") {
		$dbConnection = @mysqli_connect($server, $username, $password);
	}
	else if ($dbDriver == "pgsql") {
		$pgParms = "host=$server port=$port dbname=$database user=$username password=$password";
		$dbConnection = @pg_connect($pgParms);
	}
	return $dbConnection;
}


function isCraftConfigured(){
	$infoTable = getenv("DB_TABLE_PREFIX")."info";
	// 	get the parameters
	$environment = getenv("ENVIRONMENT");
	$dbDriver  = getenv("DB_DRIVER");
	$server   = getenv("DB_SERVER");
	$port = getenv("DB_PORT");
	$database = getenv("DB_DATABASE");
	$dbschema = getenv("DB_SCHEMA");
	$username = getenv("DB_USER");
	$password = getenv("DB_PASSWORD");
	$dbUri = "$dbDriver://$server/$database;user=$username;password=*****  ... ";
	
	
	
	$c = getConnection();
	
	if($dbDriver == "mysql") {
		$r = $c->query("SHOW TABLES LIKE '".$infoTable."'");
		if($r !== false && $result->num_rows == 1){
			$r = $c->query("SELECT COUNT(*) AS num FROM '".$infoTable."'");
			if($r !== false && $r->num > 0) {
				return true;
			}
		}
	}
	else if ($dbDriver == "pgsql") {
		$r = pg_query("SELECT EXISTS (SELECT 1 FROM pg_tables WHERE  schemaname = '$dbschema' AND tablename = '$infoTable') do_exists;");
		if($r !== false && pg_fetch_row($r)[0] === true){
			$r = pg_query("SELECT COUNT(*) AS num FROM $dbschema.$infoTable");
			if($r !== false && pg_fetch_row($r)[0] > 0) {
				return true;
			}
		}
	}
	return false;
}

?>