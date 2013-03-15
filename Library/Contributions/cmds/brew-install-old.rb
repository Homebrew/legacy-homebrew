require 'formula'
require 'formula_versions'
require 'keg'
require 'fileutils'

raise "Please `brew install git` first" unless which "git"
raise "Please `brew update' first" unless (HOMEBREW_REPOSITORY/".git").directory?

if ARGV.named.length != 2
  onoe "Usage: brew install-old <formula> <version>"
  exit 1
end

name = ARGV.shift
version = ARGV.shift

f = Formula.factory(name.downcase)
cellar = f.prefix.parent
if (cellar+version).directory?
  onoe "#{name} #{version} already in the Cellar."
  exit 2
end

puts "Searching history..."
sha = f.sha_for_version version
if sha
  ohai "Extracting formula for #{f.name}-#{version} (#{sha[0,8]})"

  FileUtils.mktemp do
    path = Pathname.new(Pathname.pwd+"#{name}.rb")
    path.write f.text_from_sha(sha)
    system "brew install #{path}"
  end
else
  onoe "Couldn't find any old record of #{name}-#{version}"
  exit 3
end
