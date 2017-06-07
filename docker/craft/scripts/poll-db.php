<?php
// usage php poll-db.php craft_conf_db.php craft_environment
// read command line arguments


$db = (include $argv[1]);
// reed the craft environment
$environment = $argv[2];
// get the parameters
$db_type  = "mysql";
$server   = $db[$environment]['server'];
$database = $db[$environment]['database'];
$username = $db[$environment]['user'];
$password = $db[$environment]['password'];
echo "testing connection [$environment]: $db_type://$server/$database;user=$username;password=*****  ... ";
// test connection
$mysqlConnection = @mysqli_connect($server, $username, $password);
if (!$mysqlConnection) {
  exit(1); // connection failed
}
exit(0); // connection ok
?>