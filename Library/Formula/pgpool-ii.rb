require 'formula'

class PgpoolIi < Formula
  homepage 'http://www.pgpool.net/mediawiki/index.php/Main_Page'
  url 'http://www.pgpool.net/download.php?f=pgpool-II-3.2.3.tar.gz'
  sha1 '5a51bead847cc5380513effc5d38973330d2cc14'

  depends_on :postgresql

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
