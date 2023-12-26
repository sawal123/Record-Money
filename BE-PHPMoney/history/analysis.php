<?php
include "../connection.php";

$id_user = $_POST['$id_user'];
$today = new DateTime($_POST['today']);
$this_month = $today->format('Y-m');

$day7 = $today->format('Y-m-d');
$day6 = date_sub($today, new DateInterval('P1D'))->format('Y-m-d');
$day5 = date_sub($today, new DateInterval('P1D'))->format('Y-m-d');
$day4 = date_sub($today, new DateInterval('P1D'))->format('Y-m-d');
$day3 = date_sub($today, new DateInterval('P1D'))->format('Y-m-d');
$day2 = date_sub($today, new DateInterval('P1D'))->format('Y-m-d');
$day1 = date_sub($today, new DateInterval('P1D'))->format('Y-m-d');
$week = array($day1, $day2, $day3, $day4, $day5, $day6, $day7);

$weekly = array(0, 0, 0, 0, 0, 0, 0);
$month_income = 0.0;
$month_outcome = 0.0;

$sql_month = "SELECT * FROM history WHERE id_user = '$id_user' AND date LIKE '%$this_month%' ORDER BY date DESC ";

$result_month = $connect->query($sql_month);

if ($result_month->num_rows > 0) {
    while ($result_month = $result_month->fetch_assoc()) {
        $type = $row_month['type'];
        $date = $row_month['date'];
        if ($type == "Pemasukan") {
            $month_income += floatval($row_month['total']);
        } else {
            $month_outcome += floatval($row_month['total']);
        }
    }
}
