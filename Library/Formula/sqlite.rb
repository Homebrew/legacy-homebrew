require 'formula'

class Sqlite < Formula
  url 'http://www.sqlite.org/sqlite-autoconf-3070500.tar.gz'
  md5 'a9604a82613ade2e7f4c303f233e477f'
  version '3.7.5'
  homepage 'http://www.sqlite.org/'

  def options
  [
    ["--with-rtree", "Enables the R*Tree index module"],
    ["--with-fts", "Enables the FTS Module"],
    ["--with-column-metadata", "Includes additional column metadata APIs. Required for sqlite3-ruby"],
    ["--with-stat2", "Enables additional query planner logic"],
    ["--with-locking-style", "Determines best locking style based on the underlying filesystem"],
    ["--universal", "Build a universal binary."]
  ]
  end

  def install
    ENV.append "CFLAGS", "-DSQLITE_ENABLE_RTREE=1" if ARGV.include? "--with-rtree"
    ENV.append "CFLAGS", "-DSQLITE_ENABLE_COLUMN_METADATA=1" if ARGV.include? "--with-column-metadata"
    ENV.append "CFLAGS", "-DSQLITE_ENABLE_STAT2=1" if ARGV.include? "--with-stat2"
    ENV.append "CFLAGS", "-DSQLITE_ENABLE_LOCKING_STYLE=1" if ARGV.include? "--with-locking-style"
    ENV.append "CPPFLAGS","-DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS" if ARGV.include? "--with-fts"
    ENV.universal_binary if ARGV.include? "--universal"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
