require 'formula'
require 'keg'

if ARGV.named.length != 2
  onoe "Usage: brew switch formula version"
  exit 1
end

name = ARGV.shift
version = ARGV.shift

# Does this formula have any versions?
f = Formula.factory(name.downcase)
cellar = f.prefix.parent
unless cellar.directory?
  onoe "#{name} not found in the Cellar."
  exit 2
end

# Does the target version exist?
unless (cellar+version).directory?
  onoe "#{name} does not have a version #{version} in the Cellar."

  versions = cellar.children.select { |pn| pn.directory? }.collect { |pn| pn.basename.to_s }
  puts "Versions available: #{versions.join(', ')}"

  exit 3
end

# Unlink all existing versions
cellar.children.select { |pn| pn.directory? }.each do |v|
  keg = Keg.new(v)
  puts "Cleaning #{keg}"
  keg.unlink
end

# Link new version

keg = Keg.new(cellar+version)
puts "#{keg.link} links created for #{keg}"