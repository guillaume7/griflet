require "rexml/document"
include REXML

def writeFile(file, start, stop, nodes, test=false)

  begin
    f = File.open(file, "w")
    id = 0
    puts "Reading section #{id} ..."
    f << "#{start}\n" if test
    nodes.each { |node|
      f << "#{start}\n" if !test
      points = node.text.split(/ +/)
      points.each { |point|
        if point.size > 3
          xyz = point.strip.chomp.split(/,/)
          f << "#{xyz[0]} #{xyz[1]} #{xyz[2]}\n"
        end
      }
      f << "#{stop}\n" if !test
      id = id + 1
      puts "Done section."
    }
    f << "#{stop}\n" if test
  ensure
    f.close
    puts "Output in file #{file}."
    puts "Done."
  end
  
end

if ARGV.size < 1
  puts "kml2xyz syntax: kml2xyz.exe filename.kml"
  puts ""
  puts "kml2xyz converts KML objects into a point, a line and a polygon MOHID files."
  exit(1)
else
  kmlfile=ARGV[0]
  #kmlfile="Sample.kml"
  if !File.exist?(kmlfile)
    puts "File #{kmlfile} doesn't exist."
    exit(2)
  end
end

puts "Reading file #{kmlfile} ..."

kmlroot = (Document.new File.new(kmlfile)).root

nodes = kmlroot.elements.to_a("//Point/coordinates")
if nodes.size != 0
  puts "Writing the #{nodes.size} point(s) .xyz file ..."
  writeFile("#{kmlfile.split(/\./)[0]}.xyz", \
            "<begin_xyz>", \
            "<end_xyz>", \
            nodes, \
            true)
end

nodes = kmlroot.elements.to_a("//LinearRing/coordinates")
if nodes.size != 0
  puts "Writing the #{nodes.size} polygon(s) .xy file ..."
  writeFile("#{kmlfile.split(/\./)[0]}.xy", \
            "<beginpolygon>", \
            "<endpolygon>", \
            nodes)
end

nodes = kmlroot.elements.to_a("//LineString/coordinates")
if nodes.size != 0
  puts "Writing the #{nodes.size} line(s) .lin file ..."
  writeFile("#{kmlfile.split(/\./)[0]}.lin", \
            "<begin_line>", \
            "<end_line>", \
            nodes)
end

