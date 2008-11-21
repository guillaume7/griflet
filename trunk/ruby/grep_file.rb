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
    else
      puts "Error: file '#{file}' doesn't exist"
    end
  end
  
end

class Grepstock < Grepfile
  
  def stockinfo(uin)
    self.extractinput(uin)
    #Need to call the setpattern method
    #Need to call the setfile method
    #Need to call the setqtype method
    #Need to correct the data output correspondingly to the setqtype method
  end
  
  #extracts a file if any
  def getfile(uin)
    patt=/-f +(\S+)[ $]/
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
  def getpattern(uin)
  end
  
end

if __FILE__ == $0 
    finance = Grepfile.new
    puts finance.grepit(/[A-Z]/)
end
