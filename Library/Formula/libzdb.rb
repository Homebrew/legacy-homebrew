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

def no_mysql?
  ARGV.include? '--without-mysql'
end

def no_postgresql?
  ARGV.include? '--without-postgresql'
end

def no_sqlite?
  ARGV.include? '--without-sqlite'
end

class Libzdb < Formula
  homepage 'http://tildeslash.com/libzdb/'
  url 'http://tildeslash.com/libzdb/dist/libzdb-2.10.2.tar.gz'
  md5 '7fc43cd79131eb989e8732f1c52b1bb6'

  depends_on PostgresInstalled.new unless no_postgresql?
  depends_on MySqlInstalled.new    unless no_mysql?
  depends_on 'sqlite'              unless no_sqlite?

  def options
    [
      ['--without-sqlite',     "Compile without SQLite support."],
      ['--without-postgresql', "Compile without PostgreSQL support."],
      ['--without-mysql',      "Compile without MySQL support."]
    ]
  end

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"]

    args << "--without-sqlite"     if no_sqlite?
    args << "--without-mysql"      if no_mysql?
    args << "--without-postgresql" if no_postgresql?

    system "./configure", *args
    system "make install"
  end
end
