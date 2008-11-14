require 'open-uri'
require 'rexml/document'
include REXML

begin
txt = open('http://codebits.sapo.pt/op/getusermap/')
#puts txt.read
doc = Document.new(txt.read)
doc.elements.each("*/user") { |element|
    str = ''
    element.attributes.each { |key,val|
        str = str + val + '; '
    }
    element.elements.each { |item|
        if item.has_text?
            str = str + '; ' + item.get_text.to_s
        end
    }
    puts str + "\n"
}

rescue
    $stderr.print "uri IO failed: " + $! + "\n"
end
