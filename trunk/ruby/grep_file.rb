require 'open-uri'

def grep_file(pattern, file="yahoofinance.txt")
#    puts file
#    puts pattern
    begin
        results = Array.new
        File.open(file, 'r') do |fs|
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

if __FILE__ == $0 
    puts grep_file(/[A-Z]/, 'stickers.txt')

end
