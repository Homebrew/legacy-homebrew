require 'cmd/outdated'
require 'cmd/install'

class Fixnum
  def plural_s
    if self > 1 then "s" else "" end
  end
end

module Homebrew extend self
  def upgrade
    if Process.uid.zero? and not File.stat(HOMEBREW_BREW_FILE).uid.zero?
      # note we only abort if Homebrew is *not* installed as sudo and the user
      # calls brew as root. The fix is to chown brew to root.
      abort "Cowardly refusing to `sudo brew upgrade'"
    end

    Homebrew.perform_preinstall_checks

    outdated = if ARGV.named.empty?
      Homebrew.outdated_brews
    else
      ARGV.formulae.select do |f|
        unless f.rack.exist? and not f.rack.children.empty?
          onoe "#{f} not installed"
        else
          true
        end
      end
    end

    # Many formulas add dependencies conditionally depending on ARGV; this is
    # done when the formula is loaded. In the long term, all uses of ARGV should
    # be removed from formulas in favor of some higher level mechanism, but for
    # now, this ensures that formulas see an ARGV with the correct options when
    # upgrading.
    saved_args = ARGV.shift(ARGV.size)
    outdated.map! do |f|
      tab = Tab.for_formula(f)
      ARGV.concat tab.used_options
      # "Forget" formula class before reloading the file, otherwise dependencies
      # are kept
      Object.class_eval{ remove_const f.class.name.to_sym }
      f = Formula.factory f.name, {:force_load => true} rescue nil
      ARGV.clear
      f
    end
    ARGV.concat(saved_args)
    # The chunk of code above can be removed once all uses of ARGV are removed
    # from formulas.

    # Expand the outdated list to include outdated dependencies then sort and
    # reduce such that dependencies are installed first and installation is not
    # attempted twice. Sorting is implicit the way `recursive_deps` returns
    # root dependencies at the head of the list and `uniq` keeps the first
    # element it encounters and discards the rest.
    outdated.map!{ |f| f.recursive_deps.reject{ |d| d.installed?} << f }
    outdated.flatten!
    outdated.uniq!

    if outdated.length > 1
      oh1 "Upgrading #{outdated.length} outdated package#{outdated.length.plural_s}, with result:"
      puts outdated.map{ |f| "#{f.name} #{f.version}" } * ", "
    end

    outdated.each do |f|
      upgrade_formula f
    end
  end

  def upgrade_formula f
    tab = Tab.for_formula(f)
    outdated_keg = Keg.new(f.linked_keg.realpath) rescue nil

    installer = FormulaInstaller.new(f, tab)
    installer.show_header = false

    oh1 "Upgrading #{f.name}"

    # first we unlink the currently active keg for this formula otherwise it is
    # possible for the existing build to interfere with the build we are about to
    # do! Seriously, it happens!
    outdated_keg.unlink if outdated_keg

    installer.install
    installer.caveats
    installer.finish
  rescue CannotInstallFormulaError => e
    onoe e
  rescue BuildError => e
    e.dump
    puts
  ensure
    # restore previous installation state if build failed
    outdated_keg.link if outdated_keg and not f.installed? rescue nil
  end

end
