# Links any Applications (.app) found in installed prefixes to /Applications
require 'keg'

module Homebrew
  def linkapps
    target_dir = ARGV.include?("--local") ? File.expand_path("~/Applications") : "/Applications"

    unless File.exist? target_dir
      opoo "#{target_dir} does not exist, stopping."
      puts "Run `mkdir #{target_dir}` first."
      exit 1
    end

    if ARGV.named.empty?
      racks = HOMEBREW_CELLAR.subdirs
      kegs = racks.map do |rack|
        keg = rack.subdirs.map { |d| Keg.new(d) }
        next if keg.empty?
        keg.detect(&:linked?) || keg.max {|a,b| a.version <=> b.version}
      end
    else
      kegs = ARGV.kegs
    end

    kegs.each do |keg|
      keg = keg.opt_record if keg.optlinked?
      Dir["#{keg}/*.app", "#{keg}/bin/*.app", "#{keg}/libexec/*.app"].each do |app|
        puts "Linking #{app}"
        app_name = File.basename(app)
        target = "#{target_dir}/#{app_name}"

        if File.exist?(target) && !File.symlink?(target)
          onoe "#{target} already exists, skipping."
          next
        end
        system "ln", "-sf", app, target_dir
      end
    end

    puts "Finished linking. Find the links under #{target_dir}."
  end
end
