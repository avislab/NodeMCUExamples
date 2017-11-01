<?
//=======================================
// Settings
//=======================================
$key = 'Ab$49nVG67cjkff4';
$file_name = 'meteo.txt';
$file_max_size = 400000;
$file_lines = 2880;  // 4*24*7 // last 7 days
//=======================================

// Save data
if (isset($_POST['data'])) {
  meteo_SaveData();
}

// Get JSON Response for charts
if (isset($_GET['chart'])) {
  $last_secconds =  preg_replace("/[^0-9]/",'', $_GET['chart']);
  if ($last_secconds < 31536001) {
      json_response($last_secconds);
  }
}

//=======================================
// FUNCTIONS
//=======================================
function hexToStr($hex){
  $string='';
  for ($i=0; $i < strlen($hex)-1; $i+=2){
    $string .= chr(hexdec($hex[$i].$hex[$i+1]));
  }
  return $string;
}

//=======================================
// Store data to file
function meteo_SaveData() {
  global $key, $file_name;

  $data =  base64_decode($_POST['data']);
  $key_data = trim(mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $key, hexToStr($_POST['key']), 'ecb'));
  
  preg_match_all("/([^,:]+),/i", $data, $fields);
  
  if ($key_data == $fields[1][0]) {
    $fp = fopen ($file_name, "a");
    fwrite ($fp, $data);
    fclose ($fp);
    meteo_DeleteOldData();
  }
  else {
    print "No";
  }
}

//=======================================
// Check file size and 
function meteo_DeleteOldData() {
  global $file_name, $file_max_size, $file_lines;
  
  if (filesize($file_name) > $file_max_size) { // if file size so big
    $file_name_tmp = $file_name.'.tmp';

    $fsrc = fopen ($file_name, "r");
    if ($fsrc)  { // if file is opened success
      $lines_count = 0;
      while (($line = fgets($fsrc)) !== false) { // count lines in the file
        $lines_count++;
      }

      if ($lines_count > $file_lines) { // if line count is more than needed then begin reduce file procedure
        rewind($fsrc);
        $fdst = fopen ($file_name_tmp, "w");
        if ($fdst) { // if temporary file is opened success
          $current_line = 0;
          while (($line = fgets($fsrc)) !== false) { // write data to temporary file
            $current_line++;
            if ($current_line > $lines_count - $file_lines) {
              fwrite($fdst, $line);
            }
          }
          fclose ($fdst); // close file
          fclose ($fsrc); // close file
          copy($file_name_tmp, $file_name); // copy file
          unlink($file_name_tmp); // remove temporary file
          print "Done";
        }
      }       
    }
  }
}

//=======================================
// Get JSON Response for charts
function json_response($last_secconds) {
  global $file_name;
  header('Content-Type: application/json');

  $dtime = time() - $last_secconds;
  $fs = fopen ($file_name, "r");
  if ($fs)  { // if file is opened success
    print '{"data":[';
    $comma = '';
    $lastline = '';
    while (($line = fgets($fs)) !== false) {
      $lastline = '{'.preg_replace("/([A-Z]):/", "\"\\1\":", trim($line)).'}';
      preg_match_all("/([A-Z]):([0-9,\.]*)/", $line, $fields);
      if ($fields[2][0] > $dtime){
        print $comma;
        $comma = ',';
        $lastline = '{'.preg_replace("/([A-Z]):/", "\"\\1\":", trim($line)).'}';
        print $lastline;
      }
    }
    if ($last_secconds == 0) {
      print $lastline;
    }
    print ']}';
    fclose ($fs); // close file
  }
}

?>