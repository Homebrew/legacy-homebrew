require 'keg'
require 'formula'

module Homebrew
  def uninstall
    raise KegUnspecifiedError if ARGV.named.empty?

    if not ARGV.force?
      ARGV.kegs.each do |keg|
        keg.lock do
          puts "Uninstalling #{keg}... (#{keg.abv})"
          keg.unlink
          keg.uninstall
          rack = keg.rack
          rm_pin rack
          if rack.directory?
            versions = rack.subdirs.map(&:basename)
            verb = versions.length == 1 ? "is" : "are"
            puts "#{keg.name} #{versions.join(", ")} #{verb} still installed."
            puts "Remove them all with `brew uninstall --force #{keg.name}`."
          end
        end
      end
    else
      ARGV.named.each do |name|
        name = Formulary.canonical_name(name)
        rack = HOMEBREW_CELLAR/name

        if rack.directory?
          puts "Uninstalling #{name}... (#{rack.abv})"
          rack.subdirs.each do |d|
            keg = Keg.new(d)
            keg.unlink
            keg.uninstall
          end
        end

        rm_pin rack
      end
    end
  rescue MultipleVersionsInstalledError => e
    ofail e
    puts "Use `brew remove --force #{e.name}` to remove all versions."
  end

  def rm_pin rack
    Formulary.from_rack(rack).unpin rescue nil
  end
end
