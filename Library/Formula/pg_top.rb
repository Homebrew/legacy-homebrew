require 'formula'

class PgTop < Formula
  homepage 'http://ptop.projects.postgresql.org/'
  url 'http://pgfoundry.org/frs/download.php/3504/pg_top-3.7.0.tar.bz2'
  sha1 '377518d95d65011b984d23fd87fb3cc91aaa1afd'

  depends_on :postgresql

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "echo '#define HAVE_DECL_STRLCPY 1' >> config.h" if MacOS.version >= :mavericks
    system "make install"
  end
end
