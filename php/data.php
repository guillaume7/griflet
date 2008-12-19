<?php
$ourFileName = "datalist.xml";
$fh = fopen($ourFileName, 'w') or die("Can't open file");
fwrite($fh, "<?xml version=\"1.0\"?>\n\n");
fwrite($fh, "<files>\n");
fwrite($fh, "<base_url>http://data.mohid.com/opendap/nph-dods</base_url>\n");
read_dir($fh,"/var","data");
fwrite($fh, "</files>");
fclose($fh) or die ("Can't close file.");
echo '<p>Coucou, this is a test</p>';
header("Refresh: 0; url=data.xml");
exit();

#Function that reads a subdir
function read_dir($fh, $infolder, $inproj){
   $folder = "$infolder/$inproj";
   $project = $inproj;
   $handle = opendir($folder) or die ("Can't open $folder");
   while($file = readdir($handle)) {
     if (!is_dir("$folder/$file")) {
        if(preg_match("/\.nc/i","$file")){
            fwrite($fh, "\t<file>\n");
            $cfolder = preg_replace('/\/var\/data/','.',$folder);
            $words  = preg_split('/\//', $cfolder);
            fwrite($fh, "\t\t<folder>$cfolder</folder>\n");
            fwrite($fh, "\t\t<name>$file</name>\n");
            fwrite($fh, "\t\t<project>$project</project>\n");
            fwrite($fh, "\t</file>\n");
        }
     } elseif (preg_match("/[a-z]/i","$file")) {
            read_dir($fh,$folder,$file);
     }
   }
   closedir($handle);
}
?>
