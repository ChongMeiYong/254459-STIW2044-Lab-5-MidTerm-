<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$radius = $_POST['radius'];

$sql = "SELECT * FROM JOB WHERE JOBWORKER IS NULL ORDER BY JOBID DESC";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["jobs"] = array();
    while ($row = $result ->fetch_assoc()){
        $joblist = array();
        $joblist[jobid] = $row["JOBID"];
        $joblist[jobtitle] = $row["JOBTITLE"];
        $joblist[jobowner] = $row["JOBOWNER"];
        $joblist[jobprice] = $row["JOBPRICE"];
        $joblist[jobdesc] = $row["JOBDESC"];
        $joblist[jobtime] = date_format(date_create($row["JOBTIME"]), 'd/m/Y h:i:s');
        $joblist[jobimage] = $row["JOBIMAGE"];
        $joblist[joblatitude] = $row["LATITUDE"];
        $joblist[joblongitude] = $row["LONGITUDE"];
        $joblist[km] = distance($latitude,$longitude,$row["LATITUDE"],$row["LONGITUDE"]);
        $joblist[jobrating] = $row["RATING"];
        //$joblist[radius] = $row["LATITUDE"];
        if (distance($latitude,$longitude,$row["LATITUDE"],$row["LONGITUDE"])<$radius){
            array_push($response["jobs"], $joblist);    
        }
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

function distance($lat1, $lon1, $lat2, $lon2) {
   $pi80 = M_PI / 180;
    $lat1 *= $pi80;
    $lon1 *= $pi80;
    $lat2 *= $pi80;
    $lon2 *= $pi80;

    $r = 6372.797; // mean radius of Earth in km
    $dlat = $lat2 - $lat1;
    $dlon = $lon2 - $lon1;
    $a = sin($dlat / 2) * sin($dlat / 2) + cos($lat1) * cos($lat2) * sin($dlon / 2) * sin($dlon / 2);
    $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
    $km = $r * $c;

    //echo '<br/>'.$km;
    return $km;
}

?>