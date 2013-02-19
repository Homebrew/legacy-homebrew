require 'formula'

class Xmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/xmp/4.0.1/xmp-4.0.1.tar.gz'
  sha1 'fc7f9e9575bb71817fbb47e8e9287a622ff59be0'

  depends_on 'libxmp'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # install the included demo song
    share.install "delicate_oooz!.mod"
  end

  def test
    system "#{bin}/xmp", "--load-only", "#{share}/delicate_oooz!.mod"
  end
end
