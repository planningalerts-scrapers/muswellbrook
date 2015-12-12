require 'scraperwiki'
require 'mechanize'
require 'htmlentities'
require 'date'

agent = Mechanize.new
url = "http://www.muswellbrook.nsw.gov.au/index.php/search-development-applications"

page = agent.get(url)

form = page.forms[1]

form['form[status][]'] = 'exhibiting'
page = form.submit

page.search('table').each do |t|

  t.search('tr').each do |r|
    next if r.at('th')
    next if r.at('td').nil? 

    # Tidy up as much as possible to reduce junk to the DB.
    address = r.search('td')[1].inner_html.split('<br>')[0].strip
    address = address.gsub /\r\n?/, ", "
    address = address.gsub /\u2013/, "-"
    address = address.gsub " - ", "-"
    address = HTMLEntities.new.decode address
    address = address.gsub(/\s+/, ' ')
    address << ", NSW, Australia"
    
    description = r.search('td')[3].inner_text
    description = description.gsub /\u2013/, "-"
    description = HTMLEntities.new.decode description
    description = description.gsub /\u00A0/, " "
    description = description.gsub(/\s+/, ' ')
    
    record = {
      :council_reference => r.search('td')[0].inner_text.strip,
      :address => address,
      :description => description,
      :date_scraped => Date.today.to_s,
      :info_url => url,
      :comment_url => 'mailto:council@muswellbrook.nsw.gov.au'
    }
    status_text = r.search('td')[3].inner_text.strip
    if status_text =~ /Exhibiting\s+until:\s+(.*)/
      record["on_notice_to"] = Date.parse($~[1]).to_s
    end

    if (ScraperWiki.select("* from data where `council_reference`='#{record[:council_reference]}'").empty? rescue true)
      puts "Saving record " + record[:council_reference]
      #puts record
      ScraperWiki.save_sqlite([:council_reference], record)
    else
      puts "Skipping already saved record " + record[:council_reference]
    end
  end
end
