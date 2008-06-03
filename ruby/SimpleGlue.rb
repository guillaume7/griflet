require "patterntransform"

#Batch glue action
glue = IsTheActionToPerformWithFiles.new("root_ConvertToHdf5Glue.dat", "gluelist.txt")
glue.usesTransformedFilesNamedAfter("GlueAction")
glue.usesAConverttohdf5BatchfileNamed("GlueAllHdf5.bat")
glue.ing
#glue.hasGeneratedAListOfOutputsIn("GlueListOfOuptuts.txt")
#glue.isTransferingTheOutputFilesTo("\\Vanessa\operational\glued")

#Batch patch action
patch = IsTheActionToPerformWithFiles.new("root_ConvertToHdf5patch.dat", "patchlist.txt")
patch.usesTransformedFilesNamedAfter("patchAction")
patch.usesAConverttohdf5BatchfileNamed("patchAllHdf5.bat")
patch.ing

#Batch convert2Netcdf action
ncconvert = IsTheActionToPerformWithFiles.new("root_Convert2Netcdf.dat", "ncconvertlist.txt")
ncconvert.usesTransformedFilesNamedAfter("Convert2Netcdf")
ncconvert.usesAConvert2netcdfBatchfileNamed("ncconvertAllHdf5.bat", )
ncconvert.ing

#Batch extract action
extract = IsTheActionToPerformWithFiles.new("root_myHDF5Extract.dat", "extractlist.txt")
extract.usesTransformedFilesNamedAfter("HDF5Extract")
extract.usesAGenericMohidtoolBatchfile("extractAllHdf5.bat", "HDF5Extractor.exe", "myHDF5extract.dat")
extract.ing

#Batch run actions
hydro = IsTheActionToPerformWithFiles.new("root_Hydrodynamic.dat", "hydrolist.txt")
hydro.usesTransformedFilesNamedAfter("Hydrodynamic")
water = IsTheActionToPerformWithFiles.new("root_WaterProperties.dat", "waterlist.txt")
water.usesTransformedFilesNamedAfter("WaterProperties")
run = IsTheActionToPerformWithFiles.new("root_nomfich.dat", "nomfichlist.txt")
run.usesTransformedFilesNamedAfter("nomfich")
run.usesAGenericMohidtoolBatchfile("Mohid.bat", "MohidWater.exe", "nomfich.dat")
run.ning
