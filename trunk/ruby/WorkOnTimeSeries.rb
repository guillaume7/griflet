require "LoadTimeSeries"

def catRuns(path, runs, timeseriefile, parameterName)
  
  parameter = Array.new
  runs.each { |run|
    timeserie = ContainsThisTimeSerie.new( path + run + '\\' + timeseriefile)
    timeserie.isExtractingParameter(parameterName).each_with_index{ |oneparam,index|
      if index%24
        parameter = parameter + [oneparam]
      end
    }
  }
  
  return parameter
  
end

path = '\\\vanessa\aplica\Biscay\Biscay_Level1\Biscay_Level2\res\Run'
runs =  ('5'..'9').to_a + ['10','11'] + ('14'..'27').to_a
corunafile = 'Coruna_North_East.srh'
gijonfile = 'Gijon_North.srh'

waterlevel = catRuns(path, runs, corunafile, 'water_level')
puts waterlevel.size