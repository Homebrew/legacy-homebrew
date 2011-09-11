require 'cmd/outdated'
require 'cmd/install'

class Fixnum
  def plural_s
    if self > 1 then "s" else "" end
  end
end

module Homebrew extend self
  def upgrade
    Homebrew.perform_preinstall_checks

    outdated = if ARGV.named.empty?
      Homebrew.outdated_brews
    else
      ARGV.formulae.each do |f|
        raise "#{f} already upgraded" if f.installed?
        raise "#{f} not installed" unless f.rack.exist? and not f.rack.children.empty?
      end
    end

    if outdated.length > 1
      oh1 "Upgrading #{outdated.length} outdated package#{outdated.length.plural_s}, with result:"
      puts outdated.map{ |f| "#{f.name} #{f.version}" } * ", "
    end

    outdated.each do |f|
      installer = FormulaInstaller.new f
      installer.show_header = false
      oh1 "Upgrading #{f.name}"
      installer.install
      Keg.new("#{f.rack}/#{f.version}").unlink
      installer.caveats
      installer.finish # includes link step
    end
  end
end
