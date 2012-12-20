require 'formula'

class PgTop < Formula
  homepage 'http://ptop.projects.postgresql.org/'
  url 'http://pgfoundry.org/frs/download.php/1781/pg_top-3.6.2.tar.gz'
  sha1 'c165a5b09ab961bf98892db94b307e31ac0cf832'

  depends_on :postgresql

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
