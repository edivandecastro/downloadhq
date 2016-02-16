require 'rubygems'
require 'mechanize'

print "Enter with URL: [http://hqcomicsonline.com.br/leitor/hq] "
url = gets.chomp
url = "http://hqcomicsonline.com.br/leitor/hq" if url.empty?

print "Enter with name of HQ: "
hq = gets.chomp

print "Enter with list of chapters: ex. 1,2,3 >> "
chapters = eval("[#{gets.chomp}]")

chapters.each do |chapter|
  agent = Mechanize.new
  pag = 0
  loop do
    pag = pag.succ
    pag = pag.to_s.rjust(2, "0") if pag.to_s.size == 1
    chapter = chapter.to_s.rjust(2, "0") if chapter.to_s.size == 1
    link = "#{url}/#{hq}/#{chapter}/#{pag}.jpg"
    begin
      agent.get(link).save "images/#{hq}/chapter #{chapter}/#{pag}.jpg"
      puts "Download #{link}"
    rescue Mechanize::ResponseCodeError => e
      break
    end
  end
  puts "Salvo com Sucesso!"
end

