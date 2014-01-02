require 'formula'

class Bashish < Formula
  homepage 'http://bashish.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/bashish/bashish/2.2.4/bashish-2.2.4.tar.gz'
  sha1 '532ed2a1c1bacafb459c2c7dedf720e9047bd716'

  depends_on 'dialog'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
