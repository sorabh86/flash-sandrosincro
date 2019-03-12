<?php
 	$upload_dir = 'images/';
	$message = "Somthing is wrong with uploading a file.";
	
	if($_FILES) {
		$type = $_POST['type'];
		$temp_name = $_FILES['Filedata']['tmp_name'];
		$file_name = $_FILES['Filedata']['name'];
		
		$file_path = $upload_dir.uniqid().'.'.getExtension($file_name);
		$result = move_uploaded_file($temp_name, $file_path);
	
		if ($result) {
			$message = '<object name="'.$type.'" type="picture">'.
							'<source>'.$file_path.'</source>'.
						'</object>';
		}
	}
	
	function getExtension($str) {
		$i = strrpos($str,".");
		if (!$i) {
			return "";
		}
		$l = strlen($str) - $i;
		$ext = substr($str,$i+1,$l);
		return $ext;
	}
	
	echo $message;
?>