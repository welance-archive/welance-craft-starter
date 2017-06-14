<?php
function adminer_object() {
  
  class AdminerSoftware extends Adminer {
    
    function name() {
      // custom name in title and heading
      return 'Welance CraftCMS';
    }
    
    
    function database() {
      // database name, will be escaped by Adminer
      return 'craft';
    }


 }
  
  return new AdminerSoftware;
}

include "./adminer-4.3.1.php";