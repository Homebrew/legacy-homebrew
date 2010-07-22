require 'formula'

class Sqlite <Formula
  url 'http://www.sqlite.org/sqlite-amalgamation-3.7.0.tar.gz'
  md5 '61b85f108760f91b79afc7833e6e6cb4'
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
