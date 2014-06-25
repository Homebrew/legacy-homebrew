require 'keg'
require 'formula'

module Homebrew
  def uninstall
    raise KegUnspecifiedError if ARGV.named.empty?

    if not ARGV.force?
      ARGV.kegs.each do |keg|
        keg.lock do
          puts "Uninstalling #{keg}..."
          keg.unlink
          keg.uninstall
          rm_pin keg.name
        end
      end
    else
      ARGV.named.each do |name|
        name = Formulary.canonical_name(name)
        rack = HOMEBREW_CELLAR/name

        if rack.directory?
          puts "Uninstalling #{name}..."
          rack.subdirs.each do |d|
            keg = Keg.new(d)
            keg.unlink
            keg.uninstall
          end
        end

        rm_pin name
      end
    end
  rescue MultipleVersionsInstalledError => e
    ofail e
    puts "Use `brew remove --force #{e.name}` to remove all versions."
  end

  def rm_pin name
    Formulary.factory(name).unpin rescue nil
  end
end
