require 'formula'

class PgTop < Formula
  url 'http://pgfoundry.org/frs/download.php/1781/pg_top-3.6.2.tar.gz'
  homepage 'http://ptop.projects.postgresql.org/'
  md5 '12ddb50cf83e3027d182a1381d388f1d'

  depends_on 'postgresql'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
