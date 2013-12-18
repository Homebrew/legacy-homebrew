require 'formula'

class PgpoolIi < Formula
  homepage 'http://www.pgpool.net/mediawiki/index.php/Main_Page'
  url 'http://www.pgpool.net/download.php?f=pgpool-II-3.2.4.tar.gz'
  sha1 '917cc7668c5e12e141aa521f0eff6e879b67d9e2'

  depends_on :postgresql

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
