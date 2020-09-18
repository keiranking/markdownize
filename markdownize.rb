require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'kramdown'
end

require 'kramdown'

filename = ARGV.first
text = File.read(filename)

frontmatter_regex = /---[\S\s]*?---/
frontmatter = text.scan(frontmatter_regex).first
body = text.sub(frontmatter, "")
body.gsub!("<!--more-->", "")

body.gsub!('<span style="font-style:italic;">', '<i>').gsub!('</span>','</i>')

paragraph_marker = "<!--p-->"
body.gsub!(/\n\n/, paragraph_marker)
markdown_body = Kramdown::Document.new(body, input: 'html').to_kramdown
markdown_body.gsub!(paragraph_marker, "").gsub!('\\', '')

File.write(filename, frontmatter + markdown_body)
puts filename + " converted to Markdown."
