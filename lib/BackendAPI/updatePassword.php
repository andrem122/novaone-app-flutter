<?php

    require 'utils.php';
    
    // user data
    $email = $_POST['email'];
    $password = $_POST['password'];
    $php_authentication_username_f = $_POST['PHPAuthenticationUsername'];
    $php_authentication_password_f = $_POST['PHPAuthenticationPassword'];
    $request_method = $_SERVER['REQUEST_METHOD'];
    
    // update POST data
    $table_name = $_POST['tableName'];
    $columns = json_decode($_POST['columns'], true);
    $object_id = $_POST['objectId'];
    
    // get and return json data if user is verified
    $user_is_verified = verify_user($email, $password, $php_authentication_username_f, $php_authentication_password_f, $request_method);
    
    // get values from columns associative array
    $password = $columns['password'];
    
    // Make django password hash
    $encrypted_password = django_make_password($password);

    $query = "UPDATE " . $table_name . " SET password = :encrypted_password WHERE id = :object_id;";
    
    // query the database and echo results
    $parameters = array(':encrypted_password' => $encrypted_password, ':object_id' => $object_id);
    echo query_db_login($query, $user_is_verified, $parameters, true, NULL);
    
?>







