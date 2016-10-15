require 'formula'

class Sqlmap < Formula
  homepage 'http://sqlmap.org/'
  url 'https://github.com/sqlmapproject/sqlmap/archive/0.9.tar.gz'
  sha1 '25d7c13fc6e8bb55a1b4d9ba60a7ebd558ad0374'
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
    unzip_dir = prefix + "#{name}-#{version}/"
    if build.head?
      inreplace "lib/parse/cmdline.py", '"\"%s\"" % _ if " " in _ else _)', ''
      inreplace "lib/parse/cmdline.py", 'usage = "%s%s [options]" % ("python " if not IS_WIN else "", \\', 'usage = "sqlmap [options]"'
    else
      inreplace "lib/parse/cmdline.py", 'usage = "python %s [options]" % sys.argv[0]', 'usage = "sqlmap [options]"'
    end
    unzip_dir.install Dir['*']
    bin.install_symlink unzip_dir+"sqlmap.py" => 'sqlmap.py'
    bin.install_symlink unzip_dir+"sqlmap.py" => 'sqlmap'
  end
end
