require 'requirement'
require 'requirements/language_module_dependency'
require 'requirements/x11_dependency'
require 'requirements/mpi_dependency'
require 'requirements/python_dependency'

class XcodeDependency < Requirement
  fatal true
  build true

  satisfy(:build_env => false) { MacOS::Xcode.installed? }

  def message; <<-EOS.undent
    A full installation of Xcode.app is required to compile this software.
    Installing just the Command Line Tools is not sufficent.
    EOS
  end
end

class MysqlDependency < Requirement
  fatal true
  default_formula 'mysql'

  satisfy { which 'mysql_config' }

  def message; <<-EOS.undent
    MySQL is required to install.

    You can install this with Homebrew using:
      brew install mysql-connector-c
        For MySQL client libraries only.

      brew install mysql
        For MySQL server.

    Or you can use an official installer from:
      http://dev.mysql.com/downloads/mysql/
    EOS
  end
end

class PostgresqlDependency < Requirement
  fatal true
  default_formula 'postgresql'

  satisfy { which 'pg_config' }

  def message
    <<-EOS.undent
      Postgres is required to install.

      You can install this with Homebrew using:
        brew install postgres

      Or you can use an official installer from:
        http://www.postgresql.org/download/macosx/
    EOS
  end
end

class TeXDependency < Requirement
  fatal true

  satisfy { which('tex') || which('latex') }

  def message; <<-EOS.undent
    A LaTeX distribution is required to install.

    You can install MacTeX distribution from:
      http://www.tug.org/mactex/

    Make sure that its bin directory is in your PATH before proceeding.

    You may also need to restore the ownership of Homebrew install:
      sudo chown -R $USER `brew --prefix`
    EOS
  end
end

class CLTDependency < Requirement
  fatal true
  build true

  satisfy(:build_env => false) { MacOS::CLT.installed? }

  def message; <<-EOS.undent
    The Command Line Tools for Xcode are required to compile this software.
    The standalone package can be obtained from http://connect.apple.com,
    or it can be installed via Xcode's preferences.
    EOS
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

  def message; <<-EOS.undent
    Mercurial is needed to install this software.

    You can install this with Homebrew using:
      brew install mercurial
    EOS
  end
end
