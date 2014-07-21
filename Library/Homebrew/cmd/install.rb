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
      # if a formula has been tapped ignore the blacklisting
      unless Formula.path(name).file?
        msg = blacklisted? name
        raise "No available formula for #{name}\n#{msg}" if msg
      end
      if not File.exist? name and name =~ HOMEBREW_TAP_FORMULA_REGEX then
        install_tap $1, $2
      end
    end unless ARGV.force?

    ARGV.formulae.each do |f|
      # Building head-only without --HEAD is an error
      if not ARGV.build_head? and f.stable.nil?
        raise CannotInstallFormulaError, <<-EOS.undent
        #{f} is a head-only formula
        Install with `brew install --HEAD #{f.name}`
        EOS
      end

      # Building stable-only with --HEAD is an error
      if ARGV.build_head? and f.head.nil?
        raise CannotInstallFormulaError, "No head is defined for #{f.name}"
      end
    end

    perform_preinstall_checks

    begin
      ARGV.formulae.each { |f| install_formula(f) }
    rescue FormulaUnavailableError => e
      ofail e.message
      puts 'Searching taps...'
      puts_columns(search_taps(query_regexp(e.name)))
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
    fi = FormulaInstaller.new(f)
    fi.options             = f.build.used_options
    fi.ignore_deps         = ARGV.ignore_deps? || ARGV.interactive?
    fi.only_deps           = ARGV.only_deps?
    fi.build_bottle        = ARGV.build_bottle?
    fi.build_from_source   = ARGV.build_from_source?
    fi.force_bottle        = ARGV.force_bottle?
    fi.interactive         = ARGV.interactive?
    fi.interactive       &&= :git if ARGV.flag? "--git"
    fi.verbose             = ARGV.verbose?
    fi.verbose           &&= :quieter if ARGV.quieter?
    fi.debug               = ARGV.debug?
    fi.prelude
    fi.install
    fi.caveats
    fi.finish
  rescue FormulaInstallationAlreadyAttemptedError
    # We already attempted to install f as part of the dependency tree of
    # another formula. In that case, don't generate an error, just move on.
  rescue FormulaAlreadyInstalledError => e
    opoo e.message
  rescue CannotInstallFormulaError => e
    ofail e.message
    check_macports
  end
end
