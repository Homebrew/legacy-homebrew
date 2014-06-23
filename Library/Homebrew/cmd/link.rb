require 'ostruct'

module Homebrew
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
        print "Linking #{keg}... "
        puts if ARGV.verbose?

        begin
          n = keg.link(mode)
        rescue Keg::LinkError
          puts
          raise
        else
          puts "#{n} symlinks created"
        end
      end
    end
  end

  private

  def keg_only?(name)
    Formulary.factory(name).keg_only?
  rescue FormulaUnavailableError
    false
  end
end
