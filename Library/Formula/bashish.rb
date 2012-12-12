require 'formula'

class Bashish < Formula
  url 'http://downloads.sourceforge.net/project/bashish/bashish/2.2.4/bashish-2.2.4.tar.gz'
  homepage 'http://bashish.sourceforge.net/'
  sha1 '532ed2a1c1bacafb459c2c7dedf720e9047bd716'

  depends_on 'dialog'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
