require 'formula'

class Xclip < Formula
  homepage 'http://xclip.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/xclip/xclip/0.12/xclip-0.12.tar.gz'
  md5 'f7e19d3e976fecdc1ea36cd39e39900d'

  depends_on :x11

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/xclip", "-version"
  end
end
