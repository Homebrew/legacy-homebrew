# Unlinks any Applications (.app) found in installed prefixes from /Applications
require 'keg'

module Homebrew
  def unlinkapps
    target_dir = ARGV.include?("--local") ? File.expand_path("~/Applications") : "/Applications"

    return unless File.exist? target_dir

    cellar_apps = Dir[target_dir + "/*"].select do |app|
      if File.symlink?(app)
        should_unlink? File.readlink(app)
      elsif File.file?(app) && alias?(app)
        should_unlink? readalias(app)
      end
    end

    cellar_apps.each do |app|
      puts "Unlinking #{app}"
      if File.symlink?(app)
        system "unlink", app
      else
        rm app
      end
    end

    puts "Finished unlinking from #{target_dir}" if cellar_apps
  end

  private

  def should_unlink? file
    if ARGV.named.empty?
      file.match(HOMEBREW_CELLAR) || file.match("#{HOMEBREW_PREFIX}/opt")
    else
      ARGV.kegs.any? { |keg| file.match(keg.to_s) || file.match(keg.opt_record.to_s) }
    end
  end

  def alias? file
    # Determine if a file is the Mac OS alias by its magic head.
    # http://en.wikipedia.org/wiki/Alias_(Mac_OS)#/File_structure
    File.read(file, 16) == "book\x00\x00\x00\x00mark\x00\x00\x00\x00"
  end

  def readalias file
    # Try to retrieve the target path of an alias.
    # http://stackoverflow.com/a/1330366
    args =<<-EOS.undent
      tell application "Finder"
        set theItem to POSIX file "#{file}" as alias
        get the POSIX path of ((original item of theItem) as text)
      end tell
    EOS
    Utils.popen_read("/usr/bin/osascript", "-e", args).strip
  end
end
