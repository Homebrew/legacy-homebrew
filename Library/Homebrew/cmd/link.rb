module Homebrew extend self

  def link
    raise KegUnspecifiedError if ARGV.named.empty?

    if Process.uid.zero? and not File.stat(HOMEBREW_BREW_FILE).uid.zero?
      # note we only abort if Homebrew is *not* installed as sudo and the user
      # calls brew as root. The fix is to chown brew to root.
      abort "Cowardly refusing to `sudo brew link'"
    end

    if ARGV.force? then mode = :force
    elsif ARGV.dry_run? then mode = :dryrun
    else mode = nil
    end

    ARGV.kegs.each do |keg|
      if keg.linked?
        opoo "Already linked: #{keg}"
        next
      end

      if mode == :dryrun
        print "Would remove:\n" do
          keg.link(mode)
        end

        next
      end

      print "Linking #{keg}... " do
        puts "#{keg.link(mode)} symlinks created"
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
