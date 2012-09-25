require 'formula'

class Fuego < Formula
  url 'http://downloads.sourceforge.net/project/fuego/fuego/1.0/fuego-1.0.tar.gz'
  homepage 'http://fuego.sourceforge.net/'
  sha1 '1fe3de726d7020278f7cb2f678a1909053bf0107'

  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
