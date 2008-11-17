require 'open-uri'

class Grepfile

    def initialize(file="yahoofinance.txt")
        @file=file
    end

    def grep(pattern)
#    puts file
#    puts pattern
        begin
            results = Array.new
            File.open(@file, 'r') do |fs|
                while line = fs.gets
                    if line.match(pattern)
                        results.push(line.chomp)
                    else
    #                    puts "Line #{line.chomp} doesn't match"
                    end
                end
            end

            if results.nil?
                "WTF means #{pattern}?\n"
            else
                results
            end

        rescue SystemCallError
             $stderr.print "IO failed: " + $! + "\n"
             "WTF! IO failed " + $! + "\n"
    
        end
    end

end

if __FILE__ == $0 
    finance = Grepfile.new
    puts finance.grep(/[A-Z]/)

end
