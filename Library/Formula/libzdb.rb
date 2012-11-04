require 'formula'

class MySqlInstalled < Requirement
  def message
    <<-EOS.undent
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

  def satisfied?
    which 'mysql_config'
  end

  def fatal?
    true
  end
end

class PostgresInstalled < Requirement
  def message
    <<-EOS.undent
      Postgres is required to install.

      You can install this with Homebrew using:
        brew install postgres

      Or you can use an official installer from:
        http://www.postgresql.org/download/macosx/
    EOS
  end

  def satisfied?
    which 'pg_config'
  end

  def fatal?
    true
  end
end

class Libzdb < Formula
  homepage 'http://tildeslash.com/libzdb/'
  url 'http://tildeslash.com/libzdb/dist/libzdb-2.10.5.tar.gz'
  sha1 '30f975e73caf58f1fa02260ed7136185a3ba2d27'

  option 'without-sqlite',     "Compile without SQLite support"
  option 'without-postgresql', "Compile without PostgreSQL support"
  option 'without-mysql',      "Compile without MySQL support"

  depends_on PostgresInstalled.new unless build.include? 'without-postgresql'
  depends_on MySqlInstalled.new    unless build.include? 'without-mysql'
  depends_on 'sqlite'              unless build.include? 'without-sqlite'

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"]

    args << "--without-sqlite"     if build.include? 'without-sqlite'
    args << "--without-mysql"      if build.include? 'without-mysql'
    args << "--without-postgresql" if build.include? 'without-postgresql'

    system "./configure", *args
    system "make install"
  end
end
