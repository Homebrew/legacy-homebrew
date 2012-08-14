require 'formula'

class Toilet < Formula
  homepage 'http://caca.zoy.org/wiki/toilet'
  url 'http://caca.zoy.org/raw-attachment/wiki/toilet/toilet-0.3.tar.gz'
  sha1 '73ea7aa2b0470ac0fecc103d7eeed0048684a505'

  depends_on 'libcaca'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
