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

if __FILE__ == $0
  
  coruna = ContainsThisTimeSerie.new('Coruna_North_East.srh')
  #coruna.isPrinting
  #time = coruna.isExtractingParameter('Seconds')
  #puts time
  
  water = coruna.isExtractingParameter('Water_level')
  puts water
  
end