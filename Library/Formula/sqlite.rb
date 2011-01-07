require 'formula'

class Sqlite <Formula
  url 'http://sqlite.org/sqlite-autoconf-3070400.tar.gz'
  md5 '8f0c690bfb33c3cbbc2471c3d9ba0158'
  version '3.7.4'
  homepage 'http://www.sqlite.org/'

  def options
  [
    ["--with-rtree", "Enables the R*Tree index module"],
    ["--with-fts", "Enables the FTS Module"],
    ["--universal", "Build a universal binary."]
  ]
  end

  def install
    ENV.append "CFLAGS", "-DSQLITE_ENABLE_RTREE=1" if ARGV.include? "--with-rtree"
    ENV.append "CPPFLAGS","-DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS" if ARGV.include? "--with-fts"
    ENV.universal_binary if ARGV.include? "--universal"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
