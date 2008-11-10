require 'open-uri'

#Yahoo financial url
yahoourl = String.new("http://download.finance.yahoo.com/d/quotes.csv")

#Stock meta-data
format = String.new("snl1t1")

#file database
datafile = String.new("yahoofinance.txt")

#Stock stickers as main argument
stickers = String.new("GOOG")
stickerslist = Array.new

#file stickers database
stickersfile = String.new("stickers.txt")

#Stock quotes text
txt = Array.new

#Read list of stickers
begin
  File.open(stickersfile, 'r') do |fs|
    
    while line = fs.gets
    
      #Filter valid stickers from bad ones
      if line.match(/^[A-Z]+$/)
        stickerslist.push(line.chomp)
      end
      
    end

    #Create a valid entry sticker format for finance.yahoo api
    stickers = stickerslist.join("+")
    
  end
  
rescue SystemCallError
 $stderr.print "IO failed: " + $! + "\n"
 
end

#Get latest stock quotes

begin

  open("#{yahoourl}?s=#{stickers}&f=#{format}") do |fu|  
    
    while line = fu.gets
      line.gsub!(/"/,'')
      line.gsub!(/,/,', ')
      txt.push(line.chomp)
    end
    
    #Alphabetical list sorting and cut repeated lines if any
    txt = txt.sort.uniq
    
  end
  
rescue
 $stderr.print "uri IO failed: " + $! + "\n"

end

#Print them on-screen
puts txt

#Update stock quotes database

ft = File.open(datafile, 'w')

begin
  ft.puts txt
  
rescue
 $stderr.print "IO failed: " + $! + "\n"
 
ensure
  ft.close
  
end
