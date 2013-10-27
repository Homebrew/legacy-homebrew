require 'formula'

class Sqlmap < Formula
  homepage 'http://sqlmap.org/'
  url 'http://github.com/sqlmapproject/sqlmap/tarball/master'
  sha1 'fb769f7b08e2e9fbaa7cdce8637c8c5879048a40'
  version '1.0-dev'
  head 'https://github.com/sqlmapproject/sqlmap.git'

  depends_on :python

  option "with-db-modules", "Installs the necessary Python modules for direct database manipulation (sqlmap.py -d)"

  if build.with? "db-modules"
    depends_on :python => 'pyodbc'
    depends_on :python => ['pymysql', 'PyMySQL']
    depends_on :python => 'cx_Oracle'
    depends_on :python => 'psycopg2'
    depends_on :python => 'pysqlite'
  end
  def install
    inreplace 'lib/parse/cmdline.py', '"\"%s\"" % _ if " " in _ else _)', ''
    inreplace 'lib/parse/cmdline.py', 'usage = "%s%s [options]" % ("python " if not IS_WIN else "", \\', 'usage = "sqlmap [options]"'
    prefix.install Dir["*"]
    bin.install_symlink prefix+"sqlmap.py" => 'sqlmap.py'
    bin.install_symlink prefix+"sqlmap.py" => 'sqlmap'
  end
end
