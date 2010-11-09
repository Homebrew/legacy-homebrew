require 'formula_installer'
require 'hardware'

module Homebrew extend self
  def install
    blacklisted? ARGV.named do |msg, name|
      abort msg
    end unless ARGV.force?

    install_formulae ARGV.formulae
  end

  def check_ppc
  case Hardware.cpu_type when :ppc, :dunno
    abort "Sorry, Homebrew does not support your computer's CPU architecture.\n"+
          "For PPC support, see: http://github.com/sceaga/homebrew/tree/powerpc"
  end
  end

  def check_writable_install_location
  raise "Cannot write to #{HOMEBREW_CELLAR}" if HOMEBREW_CELLAR.exist? and not HOMEBREW_CELLAR.writable?
  raise "Cannot write to #{HOMEBREW_PREFIX}" unless HOMEBREW_PREFIX.writable?
  end

  def check_cc
    if MACOS_VERSION >= 10.6
      opoo "You should upgrade to Xcode 3.2.3" if MacOS.llvm_build_version < RECOMMENDED_LLVM
    else
      opoo "You should upgrade to Xcode 3.1.4" if (MacOS.gcc_40_build_version < RECOMMENDED_GCC_40) or (MacOS.gcc_42_build_version < RECOMMENDED_GCC_42)
    end
  rescue
    # the reason we don't abort is some formula don't require Xcode
    # TODO allow formula to declare themselves as "not needing Xcode"
    opoo "Xcode is not installed! Builds may fail!"
  end

  def check_macports
    if MacOS.macports_or_fink_installed?
      opoo "It appears you have Macports or Fink installed"
      puts "Software installed with other package managers causes known problems for"
      puts "Homebrew. If formula fail to build uninstall Macports/Fink and reinstall any"
      puts "affected formula."
    end
  end

  def install_formulae formulae
    formulae = [formulae].flatten.compact
    return if formulae.empty?

    check_ppc
    check_writable_install_location
    check_cc
    check_macports

    formulae.each do |f|
      begin
        installer = FormulaInstaller.new f
        installer.ignore_deps = ARGV.include? '--ignore-dependencies'
        installer.go
      rescue FormulaAlreadyInstalledError => e
        opoo e.message
      end
    end
  end

  def blacklisted? names
    names.each do |name|
      msg = blacklisted_reason name
      yield msg.undent, name if msg
    end
  end

  def blacklisted_reason name
    case name
    when 'tex', 'tex-live', 'texlive' then <<-EOS
      Installing TeX from source is weird and gross, requires a lot of patches,
      and only builds 32-bit (and thus can't use Homebrew deps on Snow Leopard.)

      We recommend using a MacTeX distribution:
        http://www.tug.org/mactex/
      EOS
    when 'mercurial', 'hg' then <<-EOS
      Mercurial can be install thusly:
        brew install pip && pip install mercurial
      EOS
    when 'setuptools' then <<-EOS
      When working with a Homebrew-built Python, distribute is preferred
      over setuptools, and can be used as the prerequisite for pip.

      Install distribute using:
        brew install distribute
      EOS
    end
  end
end
