# Unlinks any Applications (.app) found in installed prefixes from /Applications
require "keg"

module Homebrew
  def unlinkapps
    target_dir = ARGV.include?("--local") ? File.expand_path("~/Applications") : "/Applications"

    return unless File.exist? target_dir

    cellar_apps = Dir[target_dir + "/*.app"].select do |app|
      if File.symlink?(app)
        should_unlink? File.readlink(app)
      end
    end

    cellar_apps.each do |app|
      puts "Unlinking #{app}"
      system "unlink", app
    end

    puts "Finished unlinking from #{target_dir}" if cellar_apps
  end

  private

  def should_unlink?(file)
    if ARGV.named.empty?
      file.match(HOMEBREW_CELLAR) || file.match("#{HOMEBREW_PREFIX}/opt")
    else
      ARGV.kegs.any? { |keg| file.match(keg.to_s) || file.match(keg.opt_record.to_s) }
    end
  end
end
