<?php
error_reporting(0);
include_once("dbconnect.php");
$jobid = $_POST['jobid'];
$sql     = "DELETE FROM JOB WHERE jobid = $jobid";
    if ($conn->query($sql) === TRUE){
        echo "success";
    }else {
        echo "failed";
    }

$conn->close();
?>