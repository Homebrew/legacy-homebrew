require 'cmd/install'

module Homebrew
  def reinstall
    ARGV.formulae.each { |f| reinstall_formula(f) }
  end

  def reinstall_formula f
    tab = Tab.for_formula(f)
    options = tab.used_options | f.build.used_options

    notice  = "Reinstalling #{f.name}"
    notice += " with #{options * ", "}" unless options.empty?
    oh1 notice

    if f.opt_prefix.directory?
      keg = Keg.new(f.opt_prefix.resolved_path)
      backup keg
    end

    fi = FormulaInstaller.new(f)
    fi.options             = options
    fi.build_bottle        = ARGV.build_bottle?
    fi.build_bottle      ||= tab.built_as_bottle && !tab.poured_from_bottle
    fi.build_from_source   = ARGV.build_from_source?
    fi.force_bottle        = ARGV.force_bottle?
    fi.verbose             = ARGV.verbose?
    fi.debug               = ARGV.debug?
    fi.prelude
    fi.install
    fi.caveats
    fi.finish
  rescue FormulaInstallationAlreadyAttemptedError
    # next
  rescue FormulaAlreadyInstalledError => e
    opoo e.message
  rescue Exception
    ignore_interrupts { restore_backup(keg, f) }
    raise
  else
    backup_path(keg).rmtree if backup_path(keg).exist?
  end

  def backup keg
    keg.unlink
    keg.rename backup_path(keg)
  end

  def restore_backup keg, formula
    path = backup_path(keg)
    if path.directory?
      path.rename keg
      keg.link unless formula.keg_only?
    end
  end

  def backup_path path
    Pathname.new "#{path}.reinstall"
  end
end
