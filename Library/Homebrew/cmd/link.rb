module Homebrew extend self

  def link
    raise KegUnspecifiedError if ARGV.named.empty?

    if Process.uid.zero? and not File.stat(HOMEBREW_BREW_FILE).uid.zero?
      # note we only abort if Homebrew is *not* installed as sudo and the user
      # calls brew as root. The fix is to chown brew to root.
      abort "Cowardly refusing to `sudo brew link'"
    end

    ARGV.kegs.each do |keg|
      if keg.linked_keg_record.directory? and keg.linked_keg_record.realpath == keg
        opoo "Already linked: #{keg}"
        next
      end

      print "Linking #{keg}... " do
        puts "#{keg.link} symlinks created"
      end
    end
  end

  private

  # Allows us to ensure a puts happens before the block exits so that if say,
  # an exception is thrown, its output starts on a new line.
  def print str, &block
    Kernel.print str
    puts_capture = Class.new do
      def self.puts str
        $did_puts = true
        Kernel.puts str
      end
    end

    puts_capture.instance_eval &block

  ensure
    puts unless $did_puts
  end

end
