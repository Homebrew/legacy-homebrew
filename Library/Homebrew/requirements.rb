require 'requirement'
require 'requirements/fortran_dependency'
require 'requirements/language_module_dependency'
require 'requirements/minimum_macos_requirement'
require 'requirements/maximum_macos_requirement'
require 'requirements/mpi_dependency'
require 'requirements/osxfuse_dependency'
require 'requirements/python_dependency'
require 'requirements/tuntap_dependency'
require 'requirements/unsigned_kext_requirement'
require 'requirements/x11_dependency'

class XcodeDependency < Requirement
  fatal true

  satisfy(:build_env => false) { xcode_installed_version }

  def initialize(tags)
    @version = tags.find { |t| tags.delete(t) if /(\d\.)+\d/ === t }
    super
  end

  def xcode_installed_version
    return false unless MacOS::Xcode.installed?
    return true unless @version
    MacOS::Xcode.version >= @version
  end

  def message
    version = " #{@version}" if @version
    message = <<-EOS.undent
      A full installation of Xcode.app#{version} is required to compile this software.
      Installing just the Command Line Tools is not sufficient.
    EOS
    if MacOS.version >= :lion
      message += <<-EOS.undent
        Xcode can be installed from the App Store.
      EOS
    else
      message += <<-EOS.undent
        Xcode can be installed from https://developer.apple.com/downloads/
      EOS
    end
  end
end

class MysqlDependency < Requirement
  fatal true
  default_formula 'mysql'

  satisfy { which 'mysql_config' }
end

class PostgresqlDependency < Requirement
  fatal true
  default_formula 'postgresql'

  satisfy { which 'pg_config' }
end

class TeXDependency < Requirement
  fatal true
  cask "mactex"
  download "http://www.tug.org/mactex/"

  satisfy { which('tex') || which('latex') }

  def message
    s = <<-EOS.undent
      A LaTeX distribution is required for Homebrew to install this formula.

      Make sure that "/usr/texbin", or the location you installed it to, is in
      your PATH before proceeding.
    EOS
    s += super
    s
  end
end

class ArchRequirement < Requirement
  fatal true

  def initialize(arch)
    @arch = arch.pop
    super
  end

  satisfy do
    case @arch
    when :x86_64 then MacOS.prefer_64_bit?
    when :intel, :ppc then Hardware::CPU.type == @arch
    end
  end

  def message
    "This formula requires an #{@arch} architecture."
  end
end

class MercurialDependency < Requirement
  fatal true
  default_formula 'mercurial'

  satisfy { which('hg') }
end

class GitDependency < Requirement
  fatal true
  default_formula 'git'
  satisfy { !!which('git') }
end

class JavaDependency < Requirement
  fatal true
  cask "java"
  download "http://www.oracle.com/technetwork/java/javase/downloads/index.html"

  satisfy { java_version }

  def initialize(tags)
    @version = tags.pop
    super
  end

  def java_version
    args = %w[/usr/libexec/java_home --failfast]
    args << "--version" << "#{@version}+" if @version
    quiet_system(*args)
  end

  def message
    version_string = " #{@version}" if @version

    s = "Java#{version_string} is required to install this formula."
    s += super
    s
  end
end

class AprDependency < Requirement
  fatal true

  satisfy(:build_env => false) { MacOS::CLT.installed? }

  def message
    message = <<-EOS.undent
      Due to packaging problems on Apple's part, software that compiles
      against APR requires the standalone Command Line Tools.
    EOS
    if MacOS.version >= :mavericks
      message += <<-EOS.undent
        Run `xcode-select --install` to install them.
      EOS
    else
      message += <<-EOS.undent
        The standalone package can be obtained from
        https://developer.apple.com/downloads/,
        or it can be installed via Xcode's preferences.
      EOS
    end
  end
end
