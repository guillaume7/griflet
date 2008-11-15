require 'open-uri'
require 'rexml/document'
include REXML

str = ''
begin
    txt = open('http://codebits.sapo.pt/op/getusermap/')
    #puts txt.read
    doc = Document.new(txt.read)
    doc.elements.each("*/user") { |element|
        element.attributes.each { |key,val|
            str = str + val + '|'
        }
        element.elements.each { |item|
            if item.has_text?
                str = str + '|' + item.get_text.to_s
            end
        }
        str = str + "\n"
    }
#    puts str
    begin
        if str.match(/guillaume/i)
            out = File.open('rfidbits.txt', 'w')
            out.write(str)
        else
            puts "Hmmm something's fishy around here!\n"
        end
    rescue
        puts "Couldn't open rfidbits.txt"
    end

rescue
    $stderr.print "uri IO failed: " + $! + "\n"
end
