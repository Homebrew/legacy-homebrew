module Homebrew extend self
  def uninstall
    unless ARGV.force?
      ARGV.kegs.each do |keg|
        puts "Uninstalling #{keg}..."
        keg.unlink
        keg.uninstall
      end
    else
      ARGV.formulae.each do |f|
        rack = f.prefix.parent
        if rack.directory?
          puts "Uninstalling #{f}..."
          rack.children do |keg|
            if keg.directory?
              keg = Keg.new(keg)
              keg.unlink
              keg.rmtree
            end
          end
          rack.rmdir
        end
      end
    end
  rescue MultipleVersionsInstalledError => e
    onoe e
    puts "Use `brew remove --force #{e.name}` to remove all versions."
  end
end
