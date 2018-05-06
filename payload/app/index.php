<h1>SERVER_ADDR: <?php echo $_SERVER['SERVER_ADDR'] ?>
<h2>BUILD: <?php $file = file_get_contents('./buildnumber.txt', FILE_USE_INCLUDE_PATH); echo $file; ?>
<br/>
<br/>
<?php phpinfo() ?>
