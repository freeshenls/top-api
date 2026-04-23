require 'nokogiri'

namespace :sync do
  desc "Purely local import from provided HTML files with Heroicons"
  task ai_bot: :environment do
    puts "Starting local import with Heroicons mapping..."
    
    sidebar_path = Rails.root.join('db', 'sidebar.html')
    content_path = Rails.root.join('db', 'import_data.html')
    
    unless File.exist?(sidebar_path) && File.exist?(content_path)
      puts "Error: Local HTML files not found."
      next
    end

    sidebar_doc = Nokogiri::HTML(File.read(sidebar_path))
    content_doc = Nokogiri::HTML(File.read(content_path))
    
    # Mapping FA/Iconfont to Heroicons
    ICON_MAP = {
      'fa-feather' => 'pencil',
      'fa-images' => 'photo',
      'fa-video' => 'video-camera',
      'fa-folder-open' => 'folder-open',
      'fa-brain' => 'cpu-chip',
      'fa-comments' => 'chat-bubble-left-right',
      'fa-code' => 'code-bracket',
      'fa-laptop-code' => 'computer-desktop',
      'fa-palette' => 'paint-brush',
      'fa-music' => 'musical-note',
      'fa-search' => 'magnifying-glass',
      'fa-graduation-cap' => 'academic-cap',
      'fa-cubes' => 'cube',
      'fa-crown' => 'star',
      'icon-instructions' => 'document-text',
      'fa-product-hunt' => 'fire'
    }

    category_map = {}

    sidebar_doc.css('li.sidebar-item').each_with_index do |item, parent_idx|
      link = item.at_css('> a')
      next unless link
      
      term_id = link['href'].delete('#')
      category_name = link.at_css('span').text.strip
      
      # Extract FA/Iconfont class and map to Heroicon
      icon_element = link.at_css('i')
      heroicon_name = 'squares-2x2' # default
      
      if icon_element
        classes = icon_element['class']
        ICON_MAP.each do |fa, hero|
          if classes.include?(fa)
            heroicon_name = hero
            break
          end
        end
      end
      
      puts "Processing Category: #{category_name} (ID: #{term_id}, Heroicon: #{heroicon_name})"
      
      category = Category.find_or_initialize_by(term_id: term_id)
      category.assign_attributes(
        name: category_name,
        icon: heroicon_name,
        position: parent_idx,
        active: true,
        parent_id: nil
      )
      category.save!
      category_map[term_id] = category
      
      sub_list = item.at_css('ul')
      if sub_list
        sub_list.css('li a').each_with_index do |sub_link, idx|
          sub_term_id = sub_link['href'].delete('#')
          sub_name = sub_link.at_css('span')&.text&.strip || sub_link.text.strip
          
          subcategory = Category.find_or_initialize_by(term_id: sub_term_id)
          subcategory.assign_attributes(
            name: sub_name,
            parent: category,
            position: idx,
            active: true,
            icon: 'chevron-right' # Default for subcategories
          )
          subcategory.save!
          category_map[sub_term_id] = subcategory
        end
      end
    end

    # Parse Content
    puts "\nExtracting sites from import_data.html..."
    
    content_doc.css('.tab-pane').each do |pane|
      tab_id = pane['id']
      term_id = tab_id.gsub('tab-', 'term-')
      category = category_map[term_id]
      
      if category
        import_local_sites(pane, category)
      end
    end
    
    content_doc.css('h4.text-gray').each do |header|
      icon = header.at_css('i.site-tag')
      term_id = icon ? icon['id'] : nil
      next unless term_id
      category = category_map[term_id]
      
      if category && category.children.empty?
        container = header.parent.next_element
        while container && !container.classes&.include?('row') && !container.at_css('.url-card')
          container = container.next_element
        end
        if container
          import_local_sites(container, category)
        end
      end
    end

    puts "\nLocal Import Complete!"
  end

  def import_local_sites(container, category)
    cards = container.css('.url-card')
    cards.each_with_index do |card, idx|
      link = card.at_css('a.card')
      next unless link
      
      name = card.at_css('strong')&.text&.strip
      url = link['data-url'] || link['href']
      description = card.at_css('p.text-muted')&.text&.strip
      icon_url = card.at_css('img')&.attr('data-src') || card.at_css('img')&.attr('src')
      
      next unless name.present?
      
      site = Site.find_or_initialize_by(name: name, category: category)
      site.assign_attributes(
        url: url,
        description: description,
        icon_url: icon_url,
        position: idx,
        active: true
      )
      
      if site.new_record? || site.changed?
        site.save!
        if icon_url.present? && !site.icon_image.attached? && icon_url.start_with?('http')
          begin
            safe_icon_url = icon_url.chars.map { |c| c.ascii_only? ? c : CGI.escape(c) }.join
            downloaded_image = URI.open(safe_icon_url, "User-Agent" => "Mozilla/5.0")
            site.icon_image.attach(io: downloaded_image, filename: File.basename(safe_icon_url))
          rescue => e
            puts "        Icon error (#{name}): #{e.message}"
          end
        end
      end
    end
  end
end
