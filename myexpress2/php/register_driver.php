<?php
//error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$name = $_POST['name'];
$radius = $_POST['radius'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$sqlinsert = "INSERT INTO DRIVER(NAME,EMAIL,PASSWORD,PHONE,VERIFY,RADIUS,CREDIT,RATING) VALUES ('$name','$email','$password','$phone','0','$radius','100','5')";

if ($conn->query($sqlinsert) === TRUE) {
    $path = '../profile/'.$email.'.jpg';
    file_put_contents($path, $decoded_string);
    sendEmail($email);
    echo "success";
} else {
    echo "failed";
}

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for MyExpress Driver'; 
    $message = 'http://alifmirzaandriyanto.com/mydriver/php/verify.php?email='.$useremail; 
    $headers = 'From: noreply@myexpress.com.my' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}
?>