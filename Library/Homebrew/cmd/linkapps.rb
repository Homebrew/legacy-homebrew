# Links any Applications (.app) found in installed prefixes to /Applications
require "keg"
require "formula"

module Homebrew
  def linkapps
    target_dir = ARGV.include?("--local") ? File.expand_path("~/Applications") : "/Applications"

    unless File.exist? target_dir
      opoo "#{target_dir} does not exist, stopping."
      puts "Run `mkdir #{target_dir}` first."
      exit 1
    end

    if ARGV.named.empty?
      kegs = Formula.racks.map do |rack|
        keg = rack.subdirs.map { |d| Keg.new(d) }
        next if keg.empty?
        keg.detect(&:linked?) || keg.max { |a, b| a.version <=> b.version }
      end
    else
      kegs = ARGV.kegs
    end

    kegs.each do |keg|
      keg.apps.each do |app|
        puts "Linking #{app} to #{target_dir}."
        target = "#{target_dir}/#{app.basename}"

        if File.exist?(target) && !File.symlink?(target)
          onoe "#{target} already exists, skipping."
          next
        end

        system "ln", "-sf", app, target_dir
      end
    end
  end
end
