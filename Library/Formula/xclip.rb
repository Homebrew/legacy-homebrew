require 'formula'


class Xclip < Formula
  homepage 'http://xclip.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/xclip/xclip/0.12/xclip-0.12.tar.gz'
  md5 'f7e19d3e976fecdc1ea36cd39e39900d'

  def install
    ENV.x11 # if your formula requires any X11 headers

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    system "#{bin}/xclip -version"
  end
end
