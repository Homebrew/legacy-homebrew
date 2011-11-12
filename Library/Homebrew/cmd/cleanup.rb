require 'formula'
require 'cmd/prune'

module Homebrew extend self
  def cleanup
    if ARGV.named.empty?
      HOMEBREW_CELLAR.children.each do |rack|
        begin
          cleanup_formula rack.basename.to_s if rack.directory?
        rescue FormulaUnavailableError => e
          # Don't complain about Cellar folders that are from DIY installs
          # instead of core formulae.
        end
      end
      # seems like a good time to do some additional cleanup
      Homebrew.prune unless ARGV.include? '-n'
    else
      ARGV.formulae.each do |f|
        cleanup_formula f
      end
    end
  end

  def cleanup_formula f
    f = Formula.factory f

    # Don't clean up keg-only brews for now.
    # Formulae link directly to them, so cleaning up old
    # ones will break already compiled software.
    if f.keg_only? and not ARGV.force?
      opoo "Skipping keg-only #{f.name}" if f.rack.children.length > 1
      return
    end

    if f.installed? and f.rack.directory?
      f.rack.children.each do |keg|
        if f.installed_prefix != keg
          print "Removing #{keg}..."
          rm_rf keg unless ARGV.include? '-n'
          puts
        end
      end
    elsif f.rack.children.length > 1
      # If the cellar only has one version installed, don't complain
      # that we can't tell which one to keep.
      opoo "Skipping #{f.name}: most recent version #{f.version} not installed"
    end
  end

end
