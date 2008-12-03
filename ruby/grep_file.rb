require 'open-uri'

class Grepfile

  def initialize(file="\\\\192.168.23.151\\guillaume\\Projects\\bots\\stock\\yahoofinance.txt")
    self.setfile(file)
  end

  def extractinput(msg)
    words=msg.split(/ +/)
    if words.length > 2 || words.length == 0
      puts "Error: message '#{msg}' is mal formed."
    else
      self.setpattern(words[0])
      if words.length == 2
        self.setfile(words[1])
      end
    end
  end
  
  def grepit(pattern=@pattern)
    reply = []
    File.open(@file) { |fs|
      puts pattern
      flag = false
      while line = fs.gets
        if line.match(pattern)
          flag = true
          reply.push(line)
        end
      end
      fs.close
      if flag == false
        reply.push("'#{pattern.to_s}' wasn't found.")
      end
    }
    @data=reply
  end

  def setpattern(txt)
    if txt.class == Regexp
      @pattern=txt
    else
      @pattern=Regexp.new(txt, 'i')
    end
  end

  def setfile(file)
    if File.exist? file
      @file=file
      puts "File '#{file}' exists"
    else
      puts "Error: file '#{file}' doesn't exist"
    end
  end
  
end

class Grepstock < Grepfile
  
  def initialize(file="\\\\192.168.23.151\\guillaume\\Projects\\bots\\stock\\yahoofinance.txt")
    self.setfile(file)
  end

  #extracts a file if any
  def getfile(uin)
    patt=/.*-f +(\s+?) +.*/
    if uin.match(patt)
      self.setfile(uin.gsub(patt, '\1'))
    end
  end
  
  #extracts the format
  def getformat(uin)
    patt=/-(\S+)[ $]/
    if uin.match(patt)
      self.setformat(uin.gsub(patt, '\1'))
    end
  end
  
  #extracts the stock pattern
  def getsticker(uin)
    patt=/.*[^-f] (\w+?) .*/
    if uin.match(patt)
      puts uin.gsub(patt, '\1')
      self.setpattern(uin.gsub(patt, '\1'))
    end
  end
  
  def stockinfo(uin)
    self.getfile(uin)
    #self.getformat(uin)
    self.getsticker(uin)
    #self.grepit
    return @data
  end

end

if __FILE__ == $0
    #finance = Grepfile.new
    #puts finance.grepit(/[A-Z]/)
    finance = Grepstock.new
    puts finance.stockinfo("-snfgh GOOG -f yahoofinance.txt")
end