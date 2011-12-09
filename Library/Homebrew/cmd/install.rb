require 'formula_installer'
require 'hardware'
require 'blacklist'

module Homebrew extend self
  def install
    ARGV.named.each do |name|
      msg = blacklisted? name
      raise "No available formula for #{name}\n#{msg}" if msg
    end unless ARGV.force?

    ARGV.formulae.each do |f|
      if File.directory? HOMEBREW_REPOSITORY/"Library/LinkedKegs/#{f.name}"
        raise "#{f} already installed\nTry: brew upgrade #{f}"
      end
    end unless ARGV.force?

    if Process.uid.zero? and not File.stat(HOMEBREW_BREW_FILE).uid.zero?
      # note we only abort if Homebrew is *not* installed as sudo and the user
      # calls brew as root. The fix is to chown brew to root.
      abort "Cowardly refusing to `sudo brew install'"
    end

    install_formulae ARGV.formulae
  end

  def check_ppc
    case Hardware.cpu_type when :ppc, :dunno
      abort <<-EOS.undent
        Sorry, Homebrew does not support your computer's CPU architecture.
        For PPC support, see: http://github.com/sceaga/homebrew/tree/powerpc
        EOS
    end
  end

  def check_writable_install_location
    raise "Cannot write to #{HOMEBREW_CELLAR}" if HOMEBREW_CELLAR.exist? and not HOMEBREW_CELLAR.writable?
    raise "Cannot write to #{HOMEBREW_PREFIX}" unless HOMEBREW_PREFIX.writable? or HOMEBREW_PREFIX.to_s == '/usr/local'
  end

  def check_cc
    if MacOS.snow_leopard?
      if MacOS.llvm_build_version < RECOMMENDED_LLVM
        opoo "You should upgrade to Xcode 3.2.6"
      end
    else
      if (MacOS.gcc_40_build_version < RECOMMENDED_GCC_40) or (MacOS.gcc_42_build_version < RECOMMENDED_GCC_42)
        opoo "You should upgrade to Xcode 3.1.4"
      end
    end
  rescue
    # the reason we don't abort is some formula don't require Xcode
    # TODO allow formula to declare themselves as "not needing Xcode"
    opoo "Xcode is not installed! Builds may fail!"
  end

  def check_macports
    if MacOS.macports_or_fink_installed?
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
    check_cc
    check_macports
    check_cellar
  end

  def install_formulae formulae
    formulae = [formulae].flatten.compact
    unless formulae.empty?
      perform_preinstall_checks
      formulae.each do |f|
        # Check formula status and skip if necessary---a formula passed on the
        # command line may have been installed to satisfy a dependency.
        next if f.installed? unless ARGV.force?

        begin
          fi = FormulaInstaller.new(f)
          fi.install
          fi.caveats
          fi.finish
        rescue FormulaAlreadyInstalledError => e
          opoo e.message
        end
      end
    end
  end
end
