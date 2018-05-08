<?php
// usage php poll-craft.php 
// check if craft is installed

require_once("poll-helpers.php");

if(isCraftConfigured()){
	exit(0);
}
exit(1);
?>