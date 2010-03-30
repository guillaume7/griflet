class IsTheActionToPerformWith
  
  attr_reader :patterncontent, :listofsubs
  attr_reader :matchline, :batch
  
  def initialize (patterncontent, listofsubs)
    @patterncontent, @listofsubs = patterncontent, listofsubs
    @listofsubs = @listofsubs.to_a if !@listofsubs.is_a?(Array)
    @matchline = @listofsubs.shift
    @matches = @matchline.tr('()','').split(' ')
    @closings = @matchline.gsub(/\(.+?\)/, '*').split(/\*| /)
    puts @closings.join(' ')
  end
  
  #private
  def thePatternIsTransformedByTheBlock
    @j = 1
    @listofsubs.each do |line|
      yield line
      @j = @j + 1
    end
  end
  
  #private
  def buildHashOfSubs(array)
    hash = Hash.new
    array.size.times { |i| hash.store(@matches[i], @closings[2*i].chomp + array[i] + @closings[2*i + 1].chomp) }
    return hash
  end
  
  def transformsInto(filename)
    
    @outfilename = filename
    thePatternIsTransformedByTheBlock{ |line|    
      filecontent = String.new( @patterncontent )

      tokens = line.split( ' ' )
      subhash = buildHashOfSubs(tokens)
      
      @matches.each { |element| 
        iselement = false
        subhash.each{ |match,sub| 
            if (match.eql? element) 
                iselement = true
            end
        }
        if !iselement 
            filecontent = String.new( filecontent.reject{|n| n.match(element)}.to_s )
        end
      }
      subhash.each { |match, sub| filecontent.replace filecontent.gsub(match, sub) }
      
      tokens = line.split( ' ' )
      subhash = buildHashOfSubs(tokens)
      subhash.each { |match, sub| filecontent.replace filecontent.gsub(match, sub) }
      
      mytrgfile = File.new(filename + "_" + @j.to_s.rjust(3,"0")  + ".dat", "w")
      mytrgfile.puts filecontent
      mytrgfile.close
      
      puts filecontent
    }
    
  end
  
  #Running
  def ing
    puts "Running #{@batchfilename}..."
  end
  
  #Running
  def ning
    ing
  end

#Method 1
  def usesTheFollowingBatchfileNameAndBlock(batchfilename)
    
    @batchfilename = batchfilename
    
    @batch = String.new
    
    batchhead = <<HEAD
    @echo off
    for %%i in (#{@outfilename}_*.dat) do (
HEAD

    yield
    
    batchfoot = <<FOOT
    )
    pause
    @echo on
FOOT
    
    puts @batchfilename
    puts batchhead + @batch + batchfoot
    
    batchfile = File.new(@batchfilename, "w")
    batchfile.puts batchhead + @batch + batchfoot
    batchfile.close
    
  end

  #Method 2
  def usesAGenericMohidtoolBatchfile(batchfilename, mohidtool, configfilename)
    usesTheFollowingBatchfileNameAndBlock(batchfilename){
      @batch = <<BATCH
      copy %%i #{configfilename}
      #{mohidtool}
BATCH
    }
  end
  
  def usesAGenericMohidtool(mohidtool, configfilename)
    usesAGenericMohidtoolBatchfile(mohidtool, "All_UseTool.bat", configfilename)
  end

#Methods 3
  def usesAConverttohdf5BatchfileNamed(batchfilename)
    usesAGenericMohidtoolBatchfile( "ConvertToHdf5.exe", batchfilename, "ConvertToHDF5Action.dat")
  end
  
  def usesAConvert2netcdfBatchfileNamed(batchfilename)
    usesAGenericMohidtoolBatchfile( "Convert2Netcdf.exe", batchfilename, "Convert2Netcdf.dat")
  end

end

class IsTheActionToPerformWithFiles < IsTheActionToPerformWith
  
  def initialize(patternfilename, listofsubsfilename)
    
    if File.exists?(patternfilename) and File.exists?(listofsubsfilename) then
      
      #patternfile = File.open(patternfilename)
      patterncontent = String.new( File.open(patternfilename).read )
      
      #listofsubsfile = File.open(listofsubsfilename)
      listofsubs = String.new( File.open(listofsubsfilename).read )
      
      super(patterncontent, listofsubs)
      
    else
      
      puts "Error: one or both of #{patternfilename} or #{listofsubsfilename} doesn't exist."
      
    end
    
  end
  
end

if __FILE__ == $0
  
mycontent = <<CONVERTTOHDF5ACTION
<begin_file>
ACTION                   : GLUES HDF5 FILES

OUTPUTFILENAME           : MOHID_WATER_01.hdf5
 
<<begin_listofsubs>>
..\\Extraction\\Stride_WaterProperties_1.hdf5
..\\Extraction\\Stride_WaterProperties_2.hdf5
<<end_listofsubs>>
<end_file>
CONVERTTOHDF5ACTION

mylistofsubs = <<listofsubs
_(01) s_(1). s_(2). (WATER) (WaterProperties)
   01      1        2    WATER   WaterProperties
   01      1        2    HYDRO   Hydrodynamic
   02      3        5    WATER   WaterProperties
   02      3        5    HYDRO   Hydrodynamic
listofsubs

  ## 1 Create ##########
  #You can create the class object with files ...
  glue = IsTheActionToPerformWithFiles.new("root_ConvertToHDF5Action.dat", "listofsubs.txt")  
  #... or with strings
  glue = IsTheActionToPerformWith.new(mycontent, mylistofsubs)  

  ## 2 Generate new files ##########
  glue.transformsInto("GlueAction")
  
  ## 3 Generate runscript ##########
  #You can easily customize the batchfile main loop ...
  glue.usesTheFollowingBatchfileNameAndBlock("GlueAllHdf5.bat") {
    glue.batch.replace <<BATCH
      copy %%i ConvertToHdf5Action.dat
      ConvertToHdf5.exe
BATCH
  }  
  #... or use a standard one
  glue.usesAConverttohdf5BatchfileNamed("GlueAllHdf5.bat")
  
  ## 4 Run ##########
  glue.ing
  
end