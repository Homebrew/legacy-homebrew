require 'requirement'
require 'requirements/apr_dependency'
require 'requirements/fortran_dependency'
require 'requirements/language_module_dependency'
require 'requirements/minimum_macos_requirement'
require 'requirements/maximum_macos_requirement'
require 'requirements/mpi_dependency'
require 'requirements/osxfuse_dependency'
require 'requirements/python_dependency'
require 'requirements/java_dependency'
require 'requirements/ruby_requirement'
require 'requirements/tuntap_dependency'
require 'requirements/unsigned_kext_requirement'
require 'requirements/x11_dependency'
require 'requirements/emacs_requirement'

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

  def inspect
    "#<#{self.class.name}: #{name.inspect} #{tags.inspect} version=#{@version.inspect}>"
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

class GPGDependency < Requirement
  fatal true
  default_formula "gpg"

  satisfy { which("gpg") || which("gpg2") }
end

class TeXDependency < Requirement
  fatal true
  cask "mactex"
  download "https://www.tug.org/mactex/"

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

