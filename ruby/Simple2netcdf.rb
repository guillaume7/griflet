require "patterntransform"

#Batch convert2Netcdf action
ncconvert = IsTheActionToPerformWithFiles.new("root_Convert2netcdf _Surface.dat", "ncconvertlist.txt")
ncconvert.usesTransformedFilesNamedAfter("Surface")
ncconvert.usesAConvert2netcdfBatchfileNamed("DoSurface.bat")
ncconvert.ing