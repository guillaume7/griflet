require 'mechanize'
require 'hpricot'
require 'twitter'
#Serve para usar o Jaiku
require 'xmlrpc/client'

#Let's add more methods to the string class...
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
    self.gsub!(/õ/, 'o')
    self.gsub!(/ã/, 'a')
    self
  end
  
  def chunk_string(average_segment_size = 135, sclice_on = /\s+/)
    out = []
    slices_estimate = self.size.divmod(average_segment_size)
    slice_count = (slices_estimate[1] > 0 ? slices_estimate[0] + 1 : slices_estimate[0])
    slice_guess = self.size / slice_count
    previous_slice_location = 0
    (1..slice_count - 1).each do |i|
      slice_location = self.nearest_split(slice_guess * i, sclice_on)
      out << self.slice(previous_slice_location..slice_location)
      previous_slice_location = slice_location + 1
    end
    out << self.slice(previous_slice_location..self.size)
    out
  end

  def nearest_split(slice_start, slice_on)
    left_scan_location  = (self.slice(0..slice_start).rindex(slice_on)).to_i
    right_scan_location = (self.slice((slice_start+1)..self.size).index(slice_on)).to_i + slice_start
    ((slice_start - left_scan_location) < (right_scan_location - slice_start) ? left_scan_location : right_scan_location)
  end

end


# Datas, mariquisse...
Agora = Time.now
Hoje = Time.local(Time.now.year, Time.now.month, Time.now.day)
Novembro = Time.local(2008, 11, 1)
Seisdatarde = Time.local(Time.now.year, Time.now.month, Time.now.day, 18, 00, 00)
Tresdatarde = Time.local(Time.now.year, Time.now.month, Time.now.day, 15, 00, 00)

# Twitter, password Base64 encoded
t = Twitter::Base.new("menuIST", "XXXXXX")

#Serve para usar o Jaiku
server = XMLRPC::Client.new2("http://api.jaiku.com/xmlrpc")

# Abre a pagina e submete o form
agent = WWW::Mechanize.new
agent.redirect_ok = true
page = agent.get 'http://www.utl.pt/page.aspx?idCat=146'
form = page.forms.first
form['__EVENTTARGET'] = "DisplayCantinas$calendar"

# Determinar dia. Se 1 de Agosto = 3135 entao hoje...
form['__EVENTARGUMENT'] = 3227 + ((Hoje - Novembro) / 24 / 60 / 60).to_i
form['DisplayCantinas$ddlCantina'] = 4
page = agent.submit form

# Recebida a página com o menuist para um dia apenas

page = Hpricot(page.content)

#macrobiotica aparece num único elemento separado por um <br /> por isso divide-se aí, ficando com uma
# array de dois elementos, o 0 é o almoço macrobiotico, jantar o 1. Mas ainda falta retirar a string 
#'Almoço/Jantar Macrobíotico:' dessa parte já dividida na <br />, pelo que se divide no : e passa-se o
# segundo elemento do vector já partido, ou seja, o que que corresponde mesmo á informação.

macro =  page.search("//span[@id='DisplayCantinas_DataList1_ctl00_Label35']").search("//font").inner_html
# Jantar
if Agora < Seisdatarde && Agora > Tresdatarde

  sopa = page.search("//span[@id='DisplayCantinas_DataList1_ctl00_Label40']").inner_html
  carne = page.search("//span[@id='DisplayCantinas_DataList1_ctl00_Label41']").inner_html
  peixe = page.search("//span[@id='DisplayCantinas_DataList1_ctl00_Label42']").inner_html
  dieta = page.search("//span[@id='DisplayCantinas_DataList1_ctl00_Label43']").inner_html
  
else

  sopa = page.search("//span[@id='DisplayCantinas_DataList1_ctl00_Label36']").inner_html
  carne = page.search("//span[@id='DisplayCantinas_DataList1_ctl00_Label37']").inner_html
  peixe = page.search("//span[@id='DisplayCantinas_DataList1_ctl00_Label38']").inner_html
  dieta = page.search("//span[@id='DisplayCantinas_DataList1_ctl00_Label39']").inner_html

end

# Enviar o menu
if !macro.nil? && !sopa.empty? && !carne.empty? && !peixe.empty? && !dieta.empty?  
  
  menu = "#{macro} | Sopa: #{sopa} | Carne: #{carne} | Peixe: #{peixe} | Dieta: #{dieta}"

 #Remover caracteres estranhos ao Jaiku e/ou twitter
  menu.limpa

  #Partir a mensagem em bocados de 135 caracteres cada
  msgs = menu.chunk_string
  msgs.each_with_index do |msg, i|
    
    #Se existir mais que um bocado de 135 caracteres,
    #então adicionar paginação no início da mensagem.
    if msgs.length != 1
      msg = "#{i+1}/#{msgs.length} #{msg}"
    end
    
    puts msg

    #Actualizar o twitter
    t.update(msg)
    
    #Actualizar o Jaiku
    result = server.call("presence.send", 
      {'user' => 'menuist', 
        'personal_key' => '8480a1766ea5fcaXXX', 
        'message' => msg} 
    )
    
  end
  
end