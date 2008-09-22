require "rexml/document"
include REXML

if ARGV.size < 1
  puts "Kml2xyz.rb syntax: ruby kml2xyz.rb filename.kml"
  exit(1)
else
  kmlfile=ARGV[0]
  if !File.exist?(kmlfile)
    puts "File #{kmlfile} doesn't exist."
    exit(2)
  end
  xyzfile="#{kmlfile.split(/\./)[0]}.xyz"
end

puts "Reading file #{kmlfile}"

kmlroot = (Document.new File.new(kmlfile)).root
nodes = kmlroot.elements.to_a("//coordinates")

puts "Found #{nodes.size} <coordinates/> sections"

begin
  f = File.open(xyzfile, "w")
  id = 0
  puts "Reading section #{id} ..."
  nodes.each { |node|
    f << "<begin_xyz>\n"
    points = node.text.split(/ +/)
    points.each { |point|
      if point.size > 3
        xyz = point.strip.chomp.split(/,/)
        f << "#{xyz[0]} #{xyz[1]} #{xyz[2]}\n"
      end
    }
    f << "<end_xyz>\n"
    id = id + 1
    puts "Done section."
  }
ensure
  f.close
  puts "Output in file #{xyzfile}."
  puts "Done."
end