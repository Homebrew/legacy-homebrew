require 'ostruct'

module Homebrew extend self

  def link
    raise KegUnspecifiedError if ARGV.named.empty?

    if Process.uid.zero? and not File.stat(HOMEBREW_BREW_FILE).uid.zero?
      raise "Cowardly refusing to `sudo brew link'\n#{SUDO_BAD_ERRMSG}"
    end

    mode = OpenStruct.new

    mode.overwrite = true if ARGV.include? '--overwrite'
    mode.dry_run = true if ARGV.dry_run?

    ARGV.kegs.each do |keg|
      if keg.linked?
        opoo "Already linked: #{keg}"
        puts "To relink: brew unlink #{keg.fname} && brew link #{keg.fname}"
        next
      end

      if mode.dry_run and mode.overwrite
        print "Would remove:\n" do
          keg.link(mode)
        end

        next
      elsif mode.dry_run
        print "Would link:\n" do
          keg.link(mode)
        end

        next
      end

      begin
        f = Formula.factory(keg.fname)
        if f.keg_only? and not ARGV.force?
          opoo "#{keg.fname} is keg-only and must be linked with --force"
          puts "Note that doing so can interfere with building software."
          next
        end
      rescue
        # Nothing to see here
      end

      keg.lock do
        print "Linking #{keg}... " do
          puts "#{keg.link(mode)} symlinks created"
        end
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
