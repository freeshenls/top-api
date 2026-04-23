require 'nokogiri'

def parse_ai_bot(html_file)
  doc = Nokogiri::HTML(File.read(html_file))
  
  # Current main category
  main_category = nil
  
  # Find all headers (Categories)
  doc.css('h4.text-gray').each do |header|
    category_name = header.text.strip
    puts "Category: #{category_name}"
    
    # Check for tabs (Subcategories)
    # The tabs are usually following the header or in a div nearby
    # In the provided HTML, tabs are in .slider_menu mini_tab
    
    # Find the container that follows the header
    container = header.next_element
    while container && !container.matches?('h4')
      if container.classes.include?('slider_menu')
        # This is a tab menu
        container.css('li.nav-item a').each do |tab_link|
          subcat_name = tab_link.text.strip
          tab_id = tab_link['href'].delete('#')
          puts "  Subcategory (Tab): #{subcat_name} (ID: #{tab_id})"
          
          # Find the tab content
          tab_pane = doc.at_css("##{tab_id}")
          if tab_pane
            parse_sites(tab_pane).each do |site|
              puts "    Site: #{site[:name]} - #{site[:url]}"
            end
          end
        end
      elsif container.classes.include?('row') || container.at_css('.url-card')
        # Direct sites without tabs
        parse_sites(container).each do |site|
          puts "  Site: #{site[:name]} - #{site[:url]}"
        end
      end
      container = container.next_element
    end
  end
end

def parse_sites(container)
  sites = []
  container.css('.url-card').each do |card|
    link = card.at_css('a.card')
    next unless link
    
    name = card.at_css('strong')&.text&.strip
    url = link['data-url'] || link['href']
    description = card.at_css('p.text-muted')&.text&.strip
    icon_url = card.at_css('img')&.attr('data-src') || card.at_css('img')&.attr('src')
    
    sites << {
      name: name,
      url: url,
      description: description,
      icon_url: icon_url
    }
  end
  sites
end

# To be used with the saved HTML file
# parse_ai_bot('db/import_data.html')
