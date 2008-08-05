class ContainsThisTimeSerie

  attr_reader :timeserie, :file, :labels
  
  def initialize(srfile)
    
    @file = srfile
    
    if File.exists?(@file)  then
      
      fid=File.open(@file)
      @timeserie = String.new( fid.read ).split(/\n/)
      fid.close
      
      @start= @timeserie.index('<BeginTimeSerie>') + 1
      @final = @timeserie.index('<EndTimeSerie>') - 1
      @labels=@timeserie[@start-2].split(/ +/)
      puts "TimeSerie loaded ..."
      
    else
      
      puts "Error: #{srfile} doesn't exist."
      
    end
    
  end
   
  def isPrinting
    puts @timeserie
  end
  
  def showsLabels
    puts @labels
  end
  
  def isExtractingParameter(paramName)
    
    if paramName.kind_of?(String)
      
      column = @labels.join(',').downcase.split(/,/).index(paramName.chomp.downcase)
      if column == nil then
        puts "Error: #{paramName} isn't a parameter."
        exit
      end
      
    else
      
      if paramName.kind_of?(Integer) then
        
        column = paramName
        
      else
        
        puts "Error: #{paramName} isn't a string nor an integer."
        exit
        
      end
      
    end
      
    results = Array.new
    
    @start.upto(@final) { |i|
      results.push( @timeserie[i].split(/ +/)[column].to_f )
    }
    
    return results
    
  end
  
end




class ContainsTheseContinuousTimeSeries
  
  attr_reader :path, :runsList, :inFile, :currentParameterName
  
  def initialize(path, runslist, infile)
    
    @inFile = infile;
    @runsList = runslist;
    @path = path;
    
  end
  
  def isExtractingParameter(parameterName)
    
    @currentParameterName = parameterName
    @parameter = Array.new
    @runsList.each { |run|
      timeserie = ContainsThisTimeSerie.new( @path + run + '\\' + @inFile)
      @parameter = @parameter + timeserie.isExtractingParameter(@currentParameterName)
      puts 'Run ' + run.to_s + ' is loaded.'
    }
    
    return @parameter
    
  end

  def currentlyHasWhichParameter?
    
    if @parameter.nil? then
      
      puts "No parameter loaded. The class variable currently has no parameter."
      
    else
      
      puts @currentParameterName
      
    end
    
  end
  
  def isWritingParameter(ouFile)
    
    if @parameter.nil? then
      
      puts "No parameter loaded. Can't write parameter."
      
    else
      
      #Write the result
      fid=File.new(ouFile, "w")
      fid.puts @parameter
      fid.close
      
    end
    
  end
  
end

if __FILE__ == $0

#  coruna = ContainsThisTimeSerie.new('Coruna_North_East.srh')
  
#  water = coruna.isExtractingParameter('Water_level')
#  puts water
  
  path = '\\\vanessa\aplica\Biscay\Biscay_Level1\Biscay_Level2\res\Run'
  runs =  ['3'] + ('5'..'9').to_a + ['10', '11'] + ('14'..'27').to_a
  level = 'water_level'

  corunalist = ContainsTheseContinuousTimeSeries.new(path, runs, 'Coruna_North_East.srh')
  corunalist.isExtractingParameter(level)
  corunalist.currentlyHasWhichParameter?()
  corunalist.isWritingParameter('coruna.txt')

end