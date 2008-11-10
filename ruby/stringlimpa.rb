require 'mechanize'
require 'hpricot'
require 'twitter'
require 'xmlrpc/client'

String.class_eval do  
  def limpa
    self.gsub!(/ó/, 'o')
    self.gsub!(/á/, 'a')
    self.gsub!(/ç/, 'c')
    self.gsub!(/é/, 'e')
    self.gsub!(/ô/, 'o')
    self.gsub!(/â/, 'a')
    self.gsub!(/ú/, 'u')
    self.gsub!(/í/, 'i')
    self.gsub!(/à/, 'a')
    self.gsub!(/ô/, 'o')
    return self
  end  
end

#menu="Macrobióca: são nações e pêlos e alvarás e estúpidos com ímpeto que comem tâmaras com brôa de mel à mooda do minho"

puts menu

puts menu