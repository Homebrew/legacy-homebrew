require 'formula'

class Xmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/xmp/4.0.0/xmp-4.0.0.tar.gz'
  sha1 '0a0b109ccc5f34756f2f1d65d6ff61b608f70758'

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
