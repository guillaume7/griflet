require 'LoadTimeSeries'

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
else
  puts 'Warning: file doesn\'t exist'
end
    

####Aladin
path = 'D:\Aplica\BiscayAplica\ConversionScripts\TimeSeries\atmosphere'
param = 'atmospheric_pressure'
listoftimeseries.each { |infile|
  puts infile
  readWriteParameter(path, '', infile, param, infile.split(/\./)[0] + '_aladin.txt')
}