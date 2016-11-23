
  require 'mechanize'
  require 'terminal-table'
  require 'tty-spinner'

  rows = []
  counter = 1



  puts 'Fetching data from web'

  mechanize = Mechanize.new
  mechanize.pluggable_parser.default = Mechanize::Download
  spinner = TTY::Spinner.new(format: :bouncing_ball)


  spinner.auto_spin
  shows = mechanize.get("http://www.serialzone.cz/serialy")
  shows.search("//div[@class='alpha fl-left']/a/@href").each  do |alphabet|
    unit = mechanize.get(alphabet)
    unit.search("//*[@id='article-line']/div[2]/div/p/a").each  do |show_link|
      show_name = show_link.search("text()")
      url = show_link.search("./@href")

      if show_name.to_s().downcase().include? ARGV[0].to_s().downcase()
        row = [counter,show_name, url]
        rows << row
        counter += 1
      end
    end
  end

  subtitle_url = ''
  if rows.count > 2
    spinner.success('Found shows')
    puts Terminal::Table.new :rows => rows
    index = $stdin.gets
    subtitle_url = rows[index.to_s.delete('\n').to_i - 1][2]
  elsif rows.count == 1
    spinner.error('Failed to find show')
  else rows.count == 2
  subtitle_url = rows[0][2]
  end

  spinner.auto_spin

  download_count = 0
  page = mechanize.get("#{subtitle_url}titulky")
    page.search("//div[@class='alpha fl-left']/a/@href").each do |link|
      season_page = mechanize.get(link)
      season_page.search("//a[@class='sub-info-menu sb-down']/@href").each do |download_link|
        if episode_id = ARGV[1]
          if download_link.to_s.downcase.include? episode_id.to_s.downcase
            mechanize.get(download_link).save()
            download_count += 1
          end
        end

      end
    end
  spinner.success("#{download_count}Subs downloaded")

