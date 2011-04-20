require 'formula'

class Sqlite < Formula
  homepage 'http://sqlite.org/'
  url 'http://www.sqlite.org/sqlite-autoconf-3070601.tar.gz'
  sha256 '79b7de2483cbbfa79721c9414d4c7acda00ba98a8b1fe73460fe57c173651ad4'
  version '3.7.6.1'

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
