require 'formula'

class Dialog <Formula
  url 'ftp://invisible-island.net/dialog/dialog.tar.gz'
  homepage 'http://invisible-island.net/dialog/'
  md5 '07d6ab77bd8c12c3def07ed72a706194'
  version '1.1.20110118'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
