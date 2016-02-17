require 'rubygems'
require 'mechanize'

class HQ
  def find_hq
    print 'Enter with URL: [http://hqcomicsonline.com.br/leitor/hq] '
    url = gets.chomp
    url = 'http://hqcomicsonline.com.br/leitor/hq' if url.empty?

    print 'Enter with name of HQ: '
    hq = gets.chomp

    print 'Enter with list of chapters: ex. 1,2,3 >> '
    chapters = eval("[#{gets.chomp}]")

    chapters.each do |chapter|
      pag = 0
      loop do
        pag = pag.succ
        pag = pag.to_s.rjust(2, '0') if pag.to_s.size == 1
        chapter = chapter.to_s.rjust(2, '0') if chapter.to_s.size == 1
        link = "#{url}/#{hq}/#{chapter}/#{pag}.jpg"
        break unless download(link, hq, chapter, pag)
      end
    end
  end

  def download(link, hq, chapter, pag)
    agent = Mechanize.new
    begin
      agent.get(link).save "images/#{hq}/chapter #{chapter}/#{pag}.jpg"
      puts "Download #{link}"
    rescue Mechanize::ResponseCodeError => e
      return try_download(link, hq, chapter, pag)
    end
    true
  end

  def try_download(link, hq, chapter, pag)
    print "It was not found link #{link} " \
          'You want to enter the link manually to try again? [Y|n] '
    opt = gets.chomp
    opt = 'y' if opt.empty?
    if opt == 'y'
      print 'Enter link for page: '
      link = gets.chomp
      download(link, hq, chapter, pag)
      puts 'Salvo com Sucesso!'
    elsif opt == 'n'
      return false
    else
      try_download(link, hq, chapter, pag)
    end
    true
  end
end

HQ.new.find_hq
