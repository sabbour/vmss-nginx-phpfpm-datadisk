<?php
    # Enable Error Reporting and Display:
    error_reporting(~0);
    ini_set('display_errors', 1);
?>

<h1>SERVER_ADDR: <?php echo $_SERVER['SERVER_ADDR'] ?>
<h2>BUILD: <?php $file = file_get_contents('./buildnumber.txt', FILE_USE_INCLUDE_PATH); echo $file; ?>
<br/>
<br/>
<?php phpinfo() ?>
