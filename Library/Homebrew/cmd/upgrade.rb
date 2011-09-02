require 'cmd/outdated'
require 'cmd/install'

class Fixnum
  def plural_s
    if self > 1 then "s" else "" end
  end
end

class Formula
  def rack
    HOMEBREW_CELLAR/name
  end
end

module Homebrew extend self
  def upgrade
    Homebrew.perform_preinstall_checks

    outdated = if ARGV.named.empty?
      Homebrew.outdated_brews
    else
      ARGV.formulae.map do |f|
        raise "#{f} already upgraded" if f.installed?
        raise "#{f} not installed" unless f.rack.exist? and not f.rack.children.empty?
        [f.prefix.parent, f.name, f.version]
      end
    end

    if outdated.length > 1
      oh1 "Upgrading #{outdated.length} outdated package#{outdated.length.plural_s}, with result:"
      puts outdated.map{ |_, name, version| "#{name} #{version}" } * ", "
    end

    outdated.each do |rack, name, version|
      installer = FormulaInstaller.new(Formula.factory(name))
      installer.show_header = false
      oh1 "Upgrading #{name}"
      installer.install
      Keg.new("#{rack}/#{version}").unlink
      installer.caveats
      installer.finish # includes link step
    end
  end
end
