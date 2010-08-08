# Links any Applications (.app) found in installed prefixes to ~/Applications
require "formula"

HOME_APPS = File.expand_path("~/Applications")

unless File.exist? HOME_APPS
  opoo "#{HOME_APPS} does not exist, stopping."
  exit 1
end

HOMEBREW_CELLAR.subdirs.each do |keg|
  next unless keg.subdirs
  name = keg.basename.to_s

  if ((f = Formula.factory(name)).installed? rescue false)
    Dir["#{f.prefix}/*.app"].each do |p|
      puts "Linking #{p}"
      appname = File.basename(p)
      target = HOME_APPS+"/"+appname
      if File.exist? target
        if File.symlink? target
          system "rm", target
        else
          onoe "#{target} already exists, skipping."
        end
      end
      system "ln", "-s", p, HOME_APPS
    end
  end
end
