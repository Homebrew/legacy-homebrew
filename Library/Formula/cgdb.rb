require 'formula'

class Cgdb < Formula
  homepage 'http://cgdb.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cgdb/cgdb/cgdb-0.6.6/cgdb-0.6.6.tar.gz'
  sha1 'bf1d9a66909a03220438a4126bb39850bdbfea65'

  depends_on 'readline'

  # man page for cgdb is only there to point people to the info page where all
  # of the actual documentation is, so skip cleaning the info to preserve the
  # documentation
  skip_clean 'share/info'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula.factory('readline').prefix}"
    system "make install"
  end
end
