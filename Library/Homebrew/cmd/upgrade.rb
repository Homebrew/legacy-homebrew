require "cmd/install"
require "cleanup"

module Homebrew
  def upgrade
    FormulaInstaller.prevent_build_flags unless MacOS.has_apple_developer_tools?

    Homebrew.perform_preinstall_checks

    if ARGV.named.empty?
      outdated = Formula.installed.select(&:outdated?)
      exit 0 if outdated.empty?
    elsif ARGV.named.any?
      outdated = ARGV.resolved_formulae.select(&:outdated?)

      (ARGV.resolved_formulae - outdated).each do |f|
        versions = f.installed_kegs.map { |keg| keg.version }
        if versions.any?
          version = versions.max
          onoe "#{f.full_name} #{version} already installed"
        else
          onoe "#{f.full_name} not installed"
        end
      end
      exit 1 if outdated.empty?
    end

    unless upgrade_pinned?
      pinned = outdated.select(&:pinned?)
      outdated -= pinned
    end

    unless outdated.empty?
      oh1 "Upgrading #{outdated.length} outdated package#{plural(outdated.length)}, with result:"
      puts outdated.map { |f| "#{f.full_name} #{f.pkg_version}" } * ", "
    else
      oh1 "No packages to upgrade"
    end

    unless upgrade_pinned? || pinned.empty?
      oh1 "Not upgrading #{pinned.length} pinned package#{plural(pinned.length)}:"
      puts pinned.map { |f| "#{f.full_name} #{f.pkg_version}" } * ", "
    end

    outdated.each do |f|
      upgrade_formula(f)
      next unless ARGV.include?("--cleanup")
      next unless f.installed?
      Homebrew::Cleanup.cleanup_formula f
    end
  end

  def upgrade_pinned?
    !ARGV.named.empty?
  end

  def upgrade_formula(f)
    outdated_keg = Keg.new(f.linked_keg.resolved_path) if f.linked_keg.directory?
    tab = Tab.for_formula(f)

    fi = FormulaInstaller.new(f)
    fi.options             = tab.used_options
    fi.ignore_deps         = ARGV.ignore_deps?
    fi.only_deps           = ARGV.only_deps?
    fi.build_bottle        = ARGV.build_bottle? || (!f.bottled? && tab.build_bottle?)
    fi.build_from_source   = ARGV.build_from_source?
    fi.verbose             = ARGV.verbose?
    fi.quieter             = ARGV.quieter?
    fi.debug               = ARGV.debug?
    fi.prelude

    oh1 "Upgrading #{f.full_name}"

    # first we unlink the currently active keg for this formula otherwise it is
    # possible for the existing build to interfere with the build we are about to
    # do! Seriously, it happens!
    outdated_keg.unlink if outdated_keg

    fi.install
    fi.finish

    # If the formula was pinned, and we were force-upgrading it, unpin and
    # pin it again to get a symlink pointing to the correct keg.
    if f.pinned?
      f.unpin
      f.pin
    end
  rescue FormulaInstallationAlreadyAttemptedError
    # We already attempted to upgrade f as part of the dependency tree of
    # another formula. In that case, don't generate an error, just move on.
  rescue CannotInstallFormulaError => e
    ofail e
  rescue BuildError => e
    e.dump
    puts
    Homebrew.failed = true
  rescue DownloadError => e
    ofail e
  ensure
    # restore previous installation state if build failed
    outdated_keg.link if outdated_keg && !f.installed? rescue nil
  end
end
