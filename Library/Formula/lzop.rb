require 'formula'

class Lzop < Formula
  url 'http://www.lzop.org/download/lzop-1.03.tar.gz'
  homepage 'http://www.lzop.org/'
  sha1 '4ee0b49b2a6b0a13572ddca5785ee48ef4c8f80f'

  depends_on 'lzo'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
