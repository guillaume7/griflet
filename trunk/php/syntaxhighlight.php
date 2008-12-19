<html>
<head>
<link type="text/css" rel="stylesheet" href="js/Styles/SyntaxHighlighter.css"></link>
</head>
<body>

<?php 
$http_file = $_GET['src'];
$tokens = preg_split("/\./", $http_file);

switch (array_pop($tokens)) {

   case "F90" :
   $lang="fortran90";
   break;

   case "f90" :
   $lang="fortran90";
   break;

   case "vb" :
   $lang="vb";
   break;

   case "cs" :
   $lang="csharp";
   break;

   case "rb" :
   $lang="ruby";
   break;

   case "pl" :
   $lang="perl";
   break;

   case "m" :
   $lang="matlab";
   break;

   case "py" :
   $lang="python";
   break;

   case "php" :
   $lang="php";
   break;

   case "js" :
   $lang="javascript";
   break;

   case "mk" :
   $lang="make";
   break;

   default :
   $lang="make";
   break;

}
?>

<pre name="code" class="<?php echo $lang ?>">
<?php readfile($http_file); ?>
</pre>

<script class="javascript" src="js/scripts/shCore.js"></script>  
<script class="javascript" src="js/scripts/shBrushCSharp.js"></script>  
<script class="javascript" src="js/scripts/shBrushPhp.js"></script>  
<script class="javascript" src="js/scripts/shBrushJscript.js"></script>  
<script class="javascript" src="js/scripts/shBrushJava.js"></script>  
<script class="javascript" src="js/scripts/shBrushVb.js"></script>  
<script class="javascript" src="js/scripts/shBrushSql.js"></script>  
<script class="javascript" src="js/scripts/shBrushXml.js"></script>  
<script class="javascript" src="js/scripts/shBrushDelphi.js"></script>  
<script class="javascript" src="js/scripts/shBrushPython.js"></script>  
<script class="javascript" src="js/scripts/shBrushRuby.js"></script>  
<script class="javascript" src="js/scripts/shBrushCss.js"></script>  
<script class="javascript" src="js/scripts/shBrushCpp.js"></script>  
<script class="javascript" src="js/scripts/shBrushScala.js"></script>  
<script class="javascript" src="js/scripts/shBrushGroovy.js"></script>  
<script class="javascript" src="js/scripts/shBrushBash.js"></script>  
<script language="javascript">
dp.SyntaxHighlighter.ClipboardSwf = '/flash/clipboard.swf';
dp.SyntaxHighlighter.HighlightAll('code');
</script>

</body>
</html>
