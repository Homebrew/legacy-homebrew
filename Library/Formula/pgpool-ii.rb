require 'formula'

class PgpoolIi < Formula
  homepage 'http://www.pgpool.net/mediawiki/index.php/Main_Page'
  url 'http://www.pgpool.net/download.php?f=pgpool-II-3.1.5.tar.gz'
  sha1 '43b84f9adbae0b4bca3284bd8ce95da441c71018'

  depends_on :postgresql

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
