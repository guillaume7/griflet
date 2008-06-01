require "roottransform"

filecontent = "root_ConvertToHDF5Action.dat"
filelist = "list.txt"

mycontent = <<CONVERTTOHDF5ACTION
<begin_file>
ACTION                   : GLUES HDF5 FILES

OUTPUTFILENAME           : MOHID_WATER_01.hdf5
 
<<begin_list>>
..\\Extraction\\Stride_WaterProperties_1.hdf5
..\\Extraction\\Stride_WaterProperties_2.hdf5
<<end_list>>
<end_file>
CONVERTTOHDF5ACTION

mylist = <<LIST
_(01) s_(1). s_(2). (WATER) (WaterProperties)
   01      1        2    WATER   WaterProperties
   01      1        2    HYDRO   Hydrodynamic
   02      3        5    WATER   WaterProperties
   02      3        5    HYDRO   Hydrodynamic
LIST

if File.exists?(filecontent) and File.exists?(filelist) then  
  glue = IsTheRootFileToTransform.new(filecontent, filelist)  
else  
  glue = IsTheRootStringToTransform.new(mycontent, mylist)  
end

glue.isTransformedIntoFile("rb_ConvertToHdf5Action")
glue.isTransformedByTheBlock { |line|
 
  filecontent = String.new( glue.rootfilecontent )
  tokens = line.split( ' ' )
  subhash = glue.buildHashOfSubs(tokens)
  
  subhash.each { |match, sub| filecontent.replace filecontent.gsub(match, sub) }
  
  mytrgfile = File.new("test_ConvertToHdf5Action_" + glue.j.to_s + ".dat", "w")
  mytrgfile.puts filecontent
  mytrgfile.close
    
  puts filecontent
  
}

glue.hasTheFollowingBatchFileBlock("GlueAllHdf5.bat") {
glue.batch.replace <<BATCH
    copy %%i ConvertToHdf5Action.dat
    ConvertToHdf5.exe
BATCH
}
#glue.usesConvertToHdf5BatchFile("GlueAllHdf5.bat")
