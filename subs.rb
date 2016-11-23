
  require 'mechanize'
  require 'terminal-table'

  rows = []


  puts 'Fetching data from web'

  mechanize = Mechanize.new
  mechanize.pluggable_parser.default = Mechanize::Download

  shows = mechanize.get("http://www.serialzone.cz/serialy")
  shows.search("//div[@class='alpha fl-left']/a/@href").each  do |alphabet|
    unit = mechanize.get(alphabet)
    unit.search("//*[@id='article-line']/div[2]/div/p/a").each  do |show_link|
      show_name = show_link.search("text()")
      url = show_link.search("./@href")
      if show_name.to_s().downcase().include? ARGV[0].to_s().downcase()
        row = [index,show_name, url]
        rows << row
      end
    end
  end

  table = Terminal::Table.new :rows => rows
  puts table


  page = mechanize.get("http://www.serialzone.cz/serial/arrow/titulky")
    page.search("//div[@class='alpha fl-left']/a/@href").each do |link|
      season_page = mechanize.get(link)
      season_page.search("//a[@class='sub-info-menu sb-down']/@href").each do |download_link|
        # mechanize.get(download_link).save()

      end
    end
