<?php
	if (isset($_REQUEST['data'])) {
		$data = $_REQUEST['data'];
		$file = fopen('scenario.xml', 'w');
		fwrite($file, base64_decode($data));
		fclose($file);
		echo $file;
	} else {
		echo '0';
	}
?>