require 'keg'
require 'formula'

module Homebrew extend self
  def uninstall
    raise KegUnspecifiedError if ARGV.named.empty?

    if not ARGV.force?
      ARGV.kegs.each do |keg|
        puts "Uninstalling #{keg}..."
        keg.unlink
        keg.uninstall
        rm_opt_link keg.fname
      end
    else
      ARGV.named.each do |name|
        name = Formula.canonical_name(name)

        # FIXME canonical_name is insane
        raise "Invalid usage" if name.include? '/'

        rack = HOMEBREW_CELLAR/name
        if rack.directory?
          puts "Uninstalling #{name}..."
          rack.children.each do |keg|
            if keg.directory?
              keg = Keg.new(keg)
              keg.unlink
              keg.rmtree
            end
          end
          rack.rmtree
        end

        rm_opt_link name
      end
    end
  rescue MultipleVersionsInstalledError => e
    ofail e
    puts "Use `brew remove --force #{e.name}` to remove all versions."
  end

  def rm_opt_link name
    optlink = HOMEBREW_PREFIX/:opt/name
    optlink.unlink if optlink.symlink?
  end

end
