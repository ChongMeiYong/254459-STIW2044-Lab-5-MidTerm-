<?php
error_reporting(0);
include_once("dbconnect.php");
$jobid = $_POST['jobid'];
$email = $_POST['email'];
$credit = $_POST['credit'];

$sql = "UPDATE JOB SET JOBWORKER = '$email'  WHERE JOBID = '$jobid'";
if ($conn->query($sql) === TRUE) {
    $newcredit = $credit - 1;
    $sqlcredit = "UPDATE DRIVER SET CREDIT = '$newcredit' WHERE EMAIL = '$email'";
    $conn->query($sqlcredit);
    echo "success";
} else {
    echo "error";
}

$conn->close();
?>
