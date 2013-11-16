# Outputs formulae that are installed but are not a dependency for
# any other installed formula.
# See: http://github.com/mxcl/homebrew/issues/issue/1438

require 'formula'
require 'set'

deps_of_installed = Set.new

Formula.installed.each do |f|
  deps_of_installed.merge f.deps.map(&:name)
end.each do |f|
  puts f.name unless deps_of_installed.include? f.name
end
