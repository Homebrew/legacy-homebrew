require 'ostruct'

module Homebrew extend self

  def link
    raise KegUnspecifiedError if ARGV.named.empty?

    mode = OpenStruct.new

    mode.overwrite = true if ARGV.include? '--overwrite'
    mode.dry_run = true if ARGV.dry_run?

    ARGV.kegs.each do |keg|
      if keg.linked?
        opoo "Already linked: #{keg}"
        puts "To relink: brew unlink #{keg.fname} && brew link #{keg.fname}"
        next
      elsif keg_only?(keg.fname) && !ARGV.force?
        opoo "#{keg.fname} is keg-only and must be linked with --force"
        puts "Note that doing so can interfere with building software."
        next
      elsif mode.dry_run && mode.overwrite
        puts "Would remove:"
        keg.link(mode)

        next
      elsif mode.dry_run
        puts "Would link:"
        keg.link(mode)

        next
      end

      keg.lock do
        print "Linking #{keg}... " do
          puts if ARGV.verbose?
          puts "#{keg.link(mode)} symlinks created"
        end
      end
    end
  end

  private

  def keg_only?(name)
    Formula.factory(name).keg_only?
  rescue FormulaUnavailableError
    false
  end

  # Allows us to ensure a puts happens before the block exits so that if say,
  # an exception is thrown, its output starts on a new line.
  def print str, &block
    Kernel.print str

    STDERR.extend Module.new {
      def puts(*args)
        unless $did_puts
          STDOUT.puts
          $did_puts = true
        end
        super
      end
    }

    puts_capture = Class.new do
      def self.puts(*args)
        $did_puts = true
        Kernel.puts(*args)
      end
    end

    puts_capture.instance_eval(&block)

  ensure
    puts unless $did_puts
  end

end
