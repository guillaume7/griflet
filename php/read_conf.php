<?php

/*
Created by Guillaume Riflet 2008-10-29
guillaume [dot] riflet [at] gmail [dot] com
*/

/*
This function converts the configuration file "$filename"
into a multidimensional array "$config".
INPUT: filename.
OUTPUT: multidimensional array.
*/
function read_conf ($filename){

    //If debugging then True. Prints what the function is reading.
    $is_print = False;

    //Create the root folder
    $config = array();

    //Read the configuration file lines
    $lines = file($filename);
    
    //Add each line's value into our multidimensional array
    foreach ($lines as $line_num => $line) {
    
        //Remove the cr-lf annoying characters
        $line = chop($line);

        //Is it a valid configuration line? If yes, then trace into. If not then jump over.
        if ( preg_match("/.+=.+/", $line) ) {
        
            //Split the configuration line's value from its full path.
            list($tree, $value) = preg_split("/=/", $line);
    
            //Now let's split the path into a list of folders.
            $folders = preg_split("/\./", $tree);
    
            //How many folders do we have?
            $num_folders = count($folders);

            //Set the current and parent folders as the root folder
            //(IMPORTANT: Set variable by reference.)
            $conf = &$config;
    
            //For each new folder create a new array, except if it's the last folder!
            //In the latter case give it its value.
            foreach ($folders as $folder_num => $folder) {
    
                //echo $folder . " is folder number " . $folder_num . "\n";
    
                //Are we at the last folder?    
                if ( $folder_num + 1 == $num_folders ) {
    
                    //Yes? Then set the value!
                    $conf[$folder] = $value;
                    if ($is_print) {
                        echo $folder . "=" . $value . "\n";
                    }
    
                }
                //We're not? Then dig and push another array.
                else {
                    
                    //Does the array already exists?
                    if ( !isset($conf[$folder]) ) {
                        //No? Then create it!
                        $conf[$folder] = array();
                    }
                    if ($is_print) {
                        echo $folder . ".";
                    }

                }

                //Set folder one level deeper.
                //(IMPORTANT: Set variable by reference.)
                $conf = &$conf[$folder];

            }

        }

    }

    return $config;

}

/*
This function reads and prints the multidimentional 
array "$config" to the stdout.
*/
function write_conf(&$config, $path="") {

    foreach ($config as $key=>$value){

        //Is it an array?
        if (is_array($value)) {
            //Yes? then go inspect the child array.
            write_conf($value, $path . $key . ".");
        }
        //No? Then print its final value.
        else {
            echo $path . $key . "=" . $value . "\n";
        }
        
    }

    $paths = preg_split("/\./", $path);
    array_pop($paths);
    $path = implode(".", $paths) . ".";

    return 1;

}

/////////////MAIN BODY//////////////////

if ($argc != 2 || in_array($argv[1], array('--help', '-help', '-h', '-?'))) {
?>

This is a command line PHP read_conf filename function

  Usage:
  <?php echo $argv[0]; ?> <filename>

  <filename> is the configuration file 
  you want to parse and store in a 
  multidimensional array. With the 
  --help, -help, -h,or -? options, 
  you can get this help.

<?php
}
else {

    $filename = $argv[1];

    $config = read_conf($filename);

    echo "\n";

    echo "This is what I read:\n";
    write_conf($config);

}

?>
