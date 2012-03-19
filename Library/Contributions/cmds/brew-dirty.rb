# See: http://github.com/mxcl/homebrew/issues/issue/1359

to_list = HOMEBREW_CELLAR.children.select { |pn| pn.directory? }
to_list.each do |d|
  versions = d.children.select { |pn| pn.directory? }.collect { |pn| pn.basename.to_s }
  puts "#{d.basename} (#{versions.join(', ')})" if versions.size > 1
end
