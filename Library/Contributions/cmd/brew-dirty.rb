# See: http://github.com/Homebrew/homebrew/issues/issue/1359

require 'keg'

HOMEBREW_CELLAR.subdirs.each do |rack|
  versions = rack.subdirs.map { |d| Keg.new(d).version }
  puts "#{rack.basename} (#{versions.join(', ')})" if versions.size > 1
end
