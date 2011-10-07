require 'formula'

class Bashish < Formula
  url 'http://downloads.sourceforge.net/project/bashish/bashish/2.2.4/bashish-2.2.4.tar.gz'
  homepage 'http://bashish.sourceforge.net/'
  md5 '0661cc0040878e921ac7a31b071d20e0'

  depends_on 'dialog'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
