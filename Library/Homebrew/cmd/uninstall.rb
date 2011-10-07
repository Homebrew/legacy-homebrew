require 'keg'

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
        if f.rack.directory?
          puts "Uninstalling #{f}..."
          f.rack.children.each do |keg|
            if keg.directory?
              keg = Keg.new(keg)
              keg.unlink
              keg.rmtree
            end
          end
          f.rack.rmtree
        end
      end
    end
  rescue MultipleVersionsInstalledError => e
    onoe e
    puts "Use `brew remove --force #{e.name}` to remove all versions."
  end
end
