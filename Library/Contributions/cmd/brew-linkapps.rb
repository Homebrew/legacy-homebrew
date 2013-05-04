# Links any Applications (.app) found in installed prefixes to ~/Applications
require "formula"

TARGET_DIR = ARGV.include?("--system") ? "/Applications" : File.expand_path("~/Applications")

unless File.exist? TARGET_DIR
  opoo "#{TARGET_DIR} does not exist, stopping."
  puts "Run `mkdir #{TARGET_DIR}` first."
  exit 1
end

HOMEBREW_CELLAR.subdirs.each do |keg|
  next unless keg.subdirs
  name = keg.basename.to_s

  if ((f = Formula.factory(name)).installed? rescue false)
    Dir["#{f.installed_prefix}/*.app", "#{f.installed_prefix}/bin/*.app", "#{f.installed_prefix}/libexec/*.app"].each do |p|
      puts "Linking #{p}"
      appname = File.basename(p)
      target = TARGET_DIR+"/"+appname
      if File.exist? target
        if File.symlink? target
          system "rm", target
        else
          onoe "#{target} already exists, skipping."
        end
      end
      system "ln", "-s", p, TARGET_DIR
    end
  end
end

puts "Finished linking. Find the links under #{TARGET_DIR}."
