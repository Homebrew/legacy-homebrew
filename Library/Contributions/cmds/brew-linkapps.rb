# Links any Applications (.app) found in installed prefixes to ~/Applications
require "formula"

HOME_APPS = File.expand_path("~/Applications")

unless File.exist? HOME_APPS
  opoo "#{HOME_APPS} does not exist, stopping."
  puts "Run `mkdir ~/Applications` first."
  exit 1
end

FINDER_ALIAS_MAGIC_PREFIX = "book\x00\x00\x00\x00mark\x00\x00\x00\x00"

def finder_alias?(filename)
  return false if not File.file? filename
  File.open(filename) do |f|
    return f.read(FINDER_ALIAS_MAGIC_PREFIX.length) == FINDER_ALIAS_MAGIC_PREFIX
  end
end

def create_finder_alias(from, to)
  system %Q{osascript -e 'tell application "Finder" to make alias file to POSIX file "#{from}" at POSIX file "#{to}"' > /dev/null}
end

HOMEBREW_CELLAR.subdirs.each do |keg|
  next unless keg.subdirs
  name = keg.basename.to_s

  if ((f = Formula.factory(name)).installed? rescue false)
    Dir["#{f.installed_prefix}/*.app", "#{f.installed_prefix}/bin/*.app", "#{f.installed_prefix}/libexec/*.app"].each do |p|
      puts "Linking #{p}"
      appname = File.basename(p, ".app")
      target = HOME_APPS+"/"+appname
      if File.exist? target
        if File.symlink?(target) || finder_alias?(target)
          system "rm", target
        else
          onoe "#{target} already exists, skipping."
        end
      end
      create_finder_alias(p, HOME_APPS)
    end
  end
end

puts "Finished linking. Find the links under ~/Applications."
