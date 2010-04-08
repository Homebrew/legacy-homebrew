require 'formula'

class Sqlite <Formula
  url 'http://www.sqlite.org/sqlite-amalgamation-3.6.23.tar.gz'
  md5 '8f1e86b3909a27f8122b0981afd16fcd'
  homepage 'http://www.sqlite.org/'

  def options
    [
      ["--with-rtree", "Enables the R*Tree index module"]
    ]
  end

  def install
    ENV.append "CFLAGS", "-DSQLITE_ENABLE_RTREE=1" if ARGV.include? "--with-rtree"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
