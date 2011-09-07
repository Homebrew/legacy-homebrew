require 'formula'

class Libwpg < Formula
  url 'http://downloads.sourceforge.net/project/libwpg/libwpg/libwpg-0.2.0/libwpg-0.2.0.tar.bz2'
  md5 '5ba6a61a2f66dfd5fee8cdd4cd262a37'
  homepage 'http://libwpg.sourceforge.net/'

  depends_on 'libwpd'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
