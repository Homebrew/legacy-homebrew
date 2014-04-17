require 'keg'
require 'formula'

module Homebrew extend self
  def uninstall
    raise KegUnspecifiedError if ARGV.named.empty?

    if not ARGV.force?
      ARGV.kegs.each do |keg|
        keg.lock do
          puts "Uninstalling #{keg}..."
          keg.unlink
          keg.uninstall
          rm_opt_link keg.fname
          rm_pin keg.fname
        end
      end
    else
      ARGV.named.each do |name|
        name = Formula.canonical_name(name)
        rack = HOMEBREW_CELLAR/name

        if rack.directory?
          puts "Uninstalling #{name}..."
          rack.subdirs.each { |d| Keg.new(d).unlink }
          rack.rmtree
        end

        rm_opt_link name
        rm_pin name
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

  def rm_pin name
    Formula.factory(name).unpin rescue nil
  end
end
