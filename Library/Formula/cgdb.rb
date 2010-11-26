require 'formula'

class Cgdb <Formula
  url 'http://downloads.sourceforge.net/project/cgdb/cgdb/cgdb-0.6.5/cgdb-0.6.5.tar.gz'
  homepage 'http://cgdb.sourceforge.net/'
  md5 'f7d054ec74b1431f3f8304195ddd21b4'

  depends_on 'readline'

  # man page for cgdb is only there to point people to the info page where all
  # of the actual documentation is, so skip cleaning the info to preserve the
  # documentation
  skip_clean 'share/info'

  # patches from MacPorts, or segfaults when run
  def patches
    { :p0 => [
      "http://trac.macports.org/export/73182/trunk/dports/devel/cgdb/files/patch-various-util-src-pseudo.c.diff",
      "http://trac.macports.org/export/73182/trunk/dports/devel/cgdb/files/patch-implicit-declaration-of-cgdb_malloc.diff"
    ]}
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula.factory('readline').prefix}"
    system "make install"
  end
end
