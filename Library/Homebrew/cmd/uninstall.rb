require "keg"
require "formula"
require "migrator"

module Homebrew
  def uninstall
    raise KegUnspecifiedError if ARGV.named.empty?

    if !ARGV.force?
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
        rack = Formulary.to_rack(name)
        name = rack.basename

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
    puts "Use `brew uninstall --force #{e.name}` to remove all versions."
  ensure
    # If we delete Cellar/newname, then Cellar/oldname symlink
    # can become broken and we have to remove it.
    if HOMEBREW_CELLAR.directory?
      HOMEBREW_CELLAR.children.each do |rack|
        rack.unlink if rack.symlink? && !rack.resolved_path_exists?
      end
    end
  end

  def rm_pin(rack)
    Formulary.from_rack(rack).unpin rescue nil
  end
end
