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
        app_name = File.basename(app, ".app")
        target = "#{target_dir}/#{app_name}"

        if File.exist?(target)
          onoe "#{target} already exists, skipping."
          next
        end

        link_app app, target_dir
      end
    end

    puts "Finished linking. Find the links under #{target_dir}."
  end

  private

  def link_app app, target_dir
    # Link app by creating Mac OS alias, so spotlight can index it.
    # http://apple.stackexchange.com/a/8103
    args = <<-EOS.undent
      tell application "Finder"
        set macSrcPath to POSIX file "#{app}" as text
        set macDestPath to POSIX file "#{target_dir}" as text
        make new alias file to file macSrcPath at folder macDestPath
      end tell
    EOS
    quiet_system "/usr/bin/osascript", "-e", args
  end
end
