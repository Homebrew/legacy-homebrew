require 'formula'

class Sqlite <Formula
  url 'http://www.sqlite.org/sqlite-amalgamation-3.6.23.1.tar.gz'
  md5 'ed585bb3d4e5c643843ebb1e318644ce'
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
