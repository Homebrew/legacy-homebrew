require "blacklist"
require "cmd/doctor"
require "cmd/search"
require "cmd/tap"
require "formula_installer"
require "hardware"

module Homebrew
  def install
    raise FormulaUnspecifiedError if ARGV.named.empty?

    if ARGV.include? '--head'
      raise "Specify `--HEAD` in uppercase to build from trunk."
    end

    ARGV.named.each do |name|
      if !File.exist?(name) && (name =~ HOMEBREW_TAP_FORMULA_REGEX \
                                || name =~ HOMEBREW_CASK_TAP_FORMULA_REGEX)
        install_tap $1, $2
      end
    end unless ARGV.force?

    begin
      formulae = []

      if ARGV.casks.any?
        brew_cask = Formulary.factory("brew-cask")
        install_formula(brew_cask) unless brew_cask.installed?
        args = []
        args << "--force" if ARGV.force?
        args << "--debug" if ARGV.debug?
        args << "--verbose" if ARGV.verbose?

        ARGV.casks.each do |c|
          cmd = "brew", "cask", "install", c, *args
          ohai cmd.join " "
          system(*cmd)
        end
      end

      ARGV.formulae.each do |f|
        # head-only without --HEAD is an error
        if not ARGV.build_head? and f.stable.nil? and f.devel.nil?
          raise <<-EOS.undent
          #{f.full_name} is a head-only formula
          Install with `brew install --HEAD #{f.full_name}`
          EOS
        end

        # devel-only without --devel is an error
        if not ARGV.build_devel? and f.stable.nil? and f.head.nil?
          raise <<-EOS.undent
          #{f.full_name} is a devel-only formula
          Install with `brew install --devel #{f.full_name}`
          EOS
        end

        if ARGV.build_stable? and f.stable.nil?
          raise "#{f.full_name} has no stable download, please choose --devel or --HEAD"
        end

        # --HEAD, fail with no head defined
        if ARGV.build_head? and f.head.nil?
          raise "No head is defined for #{f.full_name}"
        end

        # --devel, fail with no devel defined
        if ARGV.build_devel? and f.devel.nil?
          raise "No devel block is defined for #{f.full_name}"
        end

        if f.installed?
          msg = "#{f.full_name}-#{f.installed_version} already installed"
          msg << ", it's just not linked" unless f.linked_keg.symlink? or f.keg_only?
          opoo msg
        else
          formulae << f
        end
      end

      perform_preinstall_checks

      formulae.each { |f| install_formula(f) }
    rescue FormulaUnavailableError => e
      if (blacklist = blacklisted?(e.name))
        ofail "#{e.message}\n#{blacklist}"
      else
        ofail e.message
        query = query_regexp(e.name)
        puts "Searching formulae..."
        puts_columns(search_formulae(query))
        puts "Searching taps..."
        puts_columns(search_taps(query))
      end
    end
  end

  def check_ppc
    case Hardware::CPU.type when :ppc, :dunno
      abort <<-EOS.undent
        Sorry, Homebrew does not support your computer's CPU architecture.
        For PPC support, see: https://github.com/mistydemeo/tigerbrew
        EOS
    end
  end

  def check_writable_install_location
    raise "Cannot write to #{HOMEBREW_CELLAR}" if HOMEBREW_CELLAR.exist? and not HOMEBREW_CELLAR.writable_real?
    raise "Cannot write to #{HOMEBREW_PREFIX}" unless HOMEBREW_PREFIX.writable_real? or HOMEBREW_PREFIX.to_s == '/usr/local'
  end

  def check_xcode
    checks = Checks.new
    %w[
      check_for_unsupported_osx
      check_for_installed_developer_tools
      check_xcode_license_approved
      check_for_osx_gcc_installer
      check_for_bad_install_name_tool
    ].each do |check|
      out = checks.send(check)
      opoo out unless out.nil?
    end
  end

  def check_macports
    unless MacOS.macports_or_fink.empty?
      opoo "It appears you have MacPorts or Fink installed."
      puts "Software installed with other package managers causes known problems for"
      puts "Homebrew. If a formula fails to build, uninstall MacPorts/Fink and try again."
    end
  end

  def check_cellar
    FileUtils.mkdir_p HOMEBREW_CELLAR if not File.exist? HOMEBREW_CELLAR
  rescue
    raise <<-EOS.undent
      Could not create #{HOMEBREW_CELLAR}
      Check you have permission to write to #{HOMEBREW_CELLAR.parent}
    EOS
  end

  def perform_preinstall_checks
    check_ppc
    check_writable_install_location
    check_xcode
    check_cellar
  end

  def install_formula f
    f.print_tap_action

    fi = FormulaInstaller.new(f)
    fi.options             = f.build.used_options
    fi.ignore_deps         = ARGV.ignore_deps?
    fi.only_deps           = ARGV.only_deps?
    fi.build_bottle        = ARGV.build_bottle?
    fi.build_from_source   = ARGV.build_from_source?
    fi.force_bottle        = ARGV.force_bottle?
    fi.interactive         = ARGV.interactive?
    fi.git                 = ARGV.git?
    fi.verbose             = ARGV.verbose?
    fi.quieter             = ARGV.quieter?
    fi.debug               = ARGV.debug?
    fi.prelude
    fi.install
    fi.caveats
    fi.finish
  rescue FormulaInstallationAlreadyAttemptedError
    # We already attempted to install f as part of the dependency tree of
    # another formula. In that case, don't generate an error, just move on.
  rescue CannotInstallFormulaError => e
    ofail e.message
  rescue BuildError
    check_macports
    raise
  end
end
