# Links any Applications (.app) found in installed prefixes to /Applications
require 'keg'

module Homebrew extend self

  def linkapps
    target_dir = ARGV.include?("--local") ? File.expand_path("~/Applications") : "/Applications"

    unless File.exist? target_dir
      opoo "#{target_dir} does not exist, stopping."
      puts "Run `mkdir #{target_dir}` first."
      exit 1
    end

    HOMEBREW_CELLAR.subdirs.each do |rack|
      kegs = rack.subdirs.map { |d| Keg.new(d) }
      next if kegs.empty?

      keg = kegs.detect(&:linked?) || kegs.max {|a,b| a.version <=> b.version}

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
