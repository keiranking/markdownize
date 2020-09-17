require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'kramdown'
end

require 'kramdown'

def move_markdown_links_to_endnotes(text)
  full_link_regex = /\[.+?\]\(\S+\)/
  reference_regex = /\[.+?\]/

  in_place_links = text.scan(full_link_regex)
  endnote_links = in_place_links.map { |link|
    link.sub('](', ']: ').delete_suffix(')')
  }

  in_place_links.each do |link|
    text.sub!(link, link[reference_regex])
  end

  text + "\n" + "\n" + endnote_links.join("\n")
end

filename = ARGV.first
text = File.read(filename)
# File.write(filename, move_markdown_links_to_endnotes(text))
text.gsub!(/\n\n/, "<!--p-->")
text.gsub!(/\n/, "<!--br-->")
puts Kramdown::Document.new(text, input: 'html').to_kramdown
puts "Mischief managed."
