require "patterntransform"

filewithcontent = "root_ConvertToHDF5Action.dat"
filewithlist = "list.txt"

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

if File.exists?(filewithcontent) and File.exists?(filewithlist) then
  glue = IsTheActionToPerformWithFiles.new(filewithcontent, filewithlist)
else
  glue = IsTheActionToPerformWith.new(mycontent, mylist)
end

glue.usesTransformedFilesNamedAfter("GlueAction")

#Method 1
glue.usesTheFollowingBatchfileNameAndBlock("GlueAllHdf5.bat") {
  glue.batch.replace <<BATCH
    copy %%i ConvertToHdf5Action.dat
    ConvertToHdf5.exe
BATCH
}

#Method 2
glue.usesAGenericMohidtoolBatchfile("GlueAllHdf5.bat", "ConvertToHDF5.exe", "ConvertToHDF5Action.dat")

#Method3
glue.usesAConverttohdf5BatchfileNamed("GlueAllHdf5.bat")

#Execute the action
glue.ing