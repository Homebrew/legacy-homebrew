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

    if ARGV.named.empty?
      require 'cmd/outdated'
      outdated = Homebrew.outdated_brews
    else
      outdated = ARGV.formulae.select do |f|
        if f.installed?
          onoe "#{f}-#{f.installed_version} already installed"
        elsif not f.rack.exist? or f.rack.children.empty?
          onoe "#{f} not installed"
        else
          true
        end
      end
      exit 1 if outdated.empty?
    end

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

    installer = FormulaInstaller.new(f)
    installer.tab = tab
    installer.show_header = false

    oh1 "Upgrading #{f.name}"

    # first we unlink the currently active keg for this formula otherwise it is
    # possible for the existing build to interfere with the build we are about to
    # do! Seriously, it happens!
    outdated_keg.unlink if outdated_keg

    installer.install
    installer.caveats
    installer.finish
  rescue FormulaInstallationAlreadyAttemptedError
    # We already attempted to upgrade f as part of the dependency tree of
    # another formula. In that case, don't generate an error, just move on.
  rescue CannotInstallFormulaError => e
    ofail e
  rescue BuildError => e
    e.dump
    puts
    Homebrew.failed = true
  ensure
    # restore previous installation state if build failed
    outdated_keg.link if outdated_keg and not f.installed? rescue nil
  end

end
