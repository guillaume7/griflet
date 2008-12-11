infile="allurls.txt"
oufile="Sitemap.xml"

fo=File.open(oufile, 'w')
fo.puts '<?xml version="1.0" encoding="UTF-8"?>'
fo.puts '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"'
fo.puts 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'
fo.puts 'xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">'

File.open(infile, 'r') { |fi|
  while url = fi.gets
    fo.puts '  <url>'
    fo.puts '    <loc>' + url.chomp + '</loc>'
    fo.puts '    <lastmod>2008-12-12</lastmod>'
    fo.puts '    <changefreq>weekly</changefreq>'
    fo.puts '    <priority>0.5</priority>'
    fo.puts '  </url>'
  end
  fi.close
}

fo.puts '</urlset>'
fo.close
