require 'formula'
require 'tab'
require 'keg'
require 'tempfile'

module Homebrew extend self
  def catalog
    puts "Generating catalog..."
    file = Tempfile.new(['catalog', '.html'])
    file.puts "<body><table>"
    Formula.each do |f|
      file.puts "<tr><td><a href='#{f.homepage}'>#{f.name}</a></td><td>#{f.version}</td></tr>"       
    end
    file.puts "</table></body>"
    file.close
    puts "Done."
    exec "open", file.path 
  end
end
