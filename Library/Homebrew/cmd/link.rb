module Homebrew extend self
  def link
    raise KegUnspecifiedError if ARGV.named.empty?

    if Process.uid.zero? and not File.stat(HOMEBREW_BREW_FILE).uid.zero?
      # note we only abort if Homebrew is *not* installed as sudo and the user
      # calls brew as root. The fix is to chown brew to root.
      abort "Cowardly refusing to `sudo brew link'"
    end

    ARGV.kegs.each do |keg|
      print "Linking #{keg}... "
      puts if ARGV.verbose?
      begin
        puts "#{keg.link} symlinks created"
      rescue Exception
        puts
        raise
      end
    end
  end
end
