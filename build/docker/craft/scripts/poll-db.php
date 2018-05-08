<?php
// usage php poll-db.php 
// read paramters from environment variables

require_once("poll-helpers.php");
	
if (getConnection() === false) {
	exit(1);
}
exit(0);
?>