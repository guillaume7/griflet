require 'D:\projectos\GCode\ruby\LoadTimeSeries'

def readWriteParameter(path, runs, infile, parameter, oufile)
  
  timeserieList = ContainsTheseContinuousTimeSeries.new(path, runs, infile)
  timeserieList.isExtractingParameter(parameter)
  timeserieList.isWritingParameter(oufile)
  
  return timeserieList.currentlyHasWhichParameter?()
  
end

#listoftimeseries
fileoftimeseries = 'listoftimeseries.txt'
 if File.exists?(fileoftimeseries)  then
      
    fid=File.open(fileoftimeseries)
    listoftimeseries = String.new( fid.read ).split(/\n/)
    fid.close
end
    
#list
runs =  ['3'] + ('5'..'9').to_a + ['10', '11'] + ('14'..'27').to_a

##parameter
param = 'water_level'

####Level 2
path = '\\\vanessa\aplica\Biscay\Biscay_Level1\Biscay_Level2\res\Run'
listoftimeseries.each { |infile|
  readWriteParameter(path, runs, infile, param, infile.split(/\./)[0] + '_level2.txt')
}

####Level 1
path = '\\\vanessa\aplica\Biscay\Biscay_Level1\res\Run'
listoftimeseries.each { |infile|
  readWriteParameter(path, runs, infile, param, infile.split(/\./)[0] + '_level1.txt')
}
