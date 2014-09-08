# Unlinks any Applications (.app) found in installed prefixes from /Applications
require 'keg'

module Homebrew
  def unlinkapps
    target_dir = ARGV.include?("--local") ? File.expand_path("~/Applications") : "/Applications"

    unless File.exist? target_dir
      opoo "#{target_dir} does not exist, stopping."
      puts "Run `mkdir #{target_dir}` first."
      exit 1
    end

    cellar_apps = Dir[target_dir + '/*.app'].select do |app|
      if File.symlink?(app) && File.readlink(app).match(HOMEBREW_CELLAR)
        File.readlink app
      end
    end

    cellar_apps.each do |app|
      puts "Unlinking #{app}"
      system "unlink", app
    end

    puts "Finished unlinking from #{target_dir}" if cellar_apps
  end
end
