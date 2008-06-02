class IsTheRootStringToTransform
  
  attr_reader :rootfilecontent, :list, :matches 
  attr_reader :matchexpr, :j, :outfilename, :batch
  
  def initialize (rootstring, list)
    @rootfilecontent, @list = rootstring, list
    @list = @list.to_a if !@list.is_a?(Array)
    @matchexpr = @list.shift
    @matches = @matchexpr.tr('()','').split(' ')
    @closings = @matchexpr.gsub(/\(.+?\)/, '*').split(/\*| /)
    puts @closings.join(' ')
  end
  
  def isTransformedByTheBlock
    @j = 1
    @list.each do |line|
      yield line
      @j = @j + 1
    end
  end
  
  def buildHashOfSubs(array)
    hash = Hash.new
    array.size.times { |i| hash.store(@matches[i], @closings[2*i].chomp + array[i] + @closings[2*i + 1].chomp) }
    return hash
  end
  
  def isTransformedIntoFile(filename)
    
    @outfilename = filename
    isTransformedByTheBlock{ |line|    
      filecontent = String.new( @rootfilecontent )
      
      tokens = line.split( ' ' )
      subhash = buildHashOfSubs(tokens)
      subhash.each { |match, sub| filecontent.replace filecontent.gsub(match, sub) }
      
      mytrgfile = File.new(filename + "_" + @j.to_s.rjust(3,"0")  + ".dat", "w")
      mytrgfile.puts filecontent
      mytrgfile.close
      
      puts filecontent
    }
    
  end
  
  def hasTheFollowingBatchFileBlock(batchfilename)
    
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

    batchfile = File.new(batchfilename, "w")
    batchfile.puts batchhead + @batch + batchfoot
    batchfile.close
    
  end
  
#  def usesConvertToHdf5BatchFile(batchfilename)
#   hasTheFollowingBatchFileBlock(batchfilename){
#@batch.replace <<BATCH
#    copy %%i ConvertToHdf5Action.dat
#    ConvertToHdf5.exe
#BATCH
#}
end

class IsTheRootFileToTransform < IsTheRootStringToTransform
  
  def initialize(rootfilename, listfilename)
    
    if File.exists?(rootfilename) and File.exists?(listfilename) then
      
      rootfile = File.open(rootfilename)
      rootstring = String.new( rootfile.read )
      
      listfile = File.open(listfilename)
      list = String.new( listfile.read )
      
      super(rootstring, list)
      
    else
      
      puts "Error: one or both of #{rootfile} or #{listfile} doesn't exist."
      
    end
    
  end
  
end

if __FILE__ == $0
  
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

  if File.exists?("0list.txt") then
    mysrcfile = File.open("list.txt") 
    mylist.replace mysrcfile.read
    mysrcfile.close
  else
    puts "Error: file list.txt doesn't exists"
  end

  glue = IsTheRootStringToTransform.new(mycontent, mylist)

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

  glue.isTransformedIntoFile("Coucou_ConvertToHdf5Action")
  
end