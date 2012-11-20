require 'formula'
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

# Does this formula have any versions?
f = Formula.factory(name.downcase)
cellar = f.prefix.parent
if (cellar+version).directory?
    onoe "#{name} #{version} already in the Cellar."
    exit 2
end

puts "Searching history..."
sha_lines = `brew versions #{name}`.each_line.select{|l|l.start_with? "#{version} "}
if sha_lines.length == 1
    version = sha_lines[0].split[0]
    sha = sha_lines[0].split[3]
    ohai "Extracting formula for #{name}-#{version} (#{sha})"

    def text_from_sha sha, name
      HOMEBREW_REPOSITORY.cd do
        `git cat-file blob #{sha}:Library/Formula/#{name}.rb`
      end
    end

    FileUtils.mktemp do
        path = Pathname.new(Pathname.pwd+"#{name}.rb")
        path.write text_from_sha(sha, name)
        system "brew install #{path}"
    end
else
    onoe "Couldn't find any old record of #{name}-#{version}"
    exit 3
end
