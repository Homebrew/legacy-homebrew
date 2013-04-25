require 'formula'

class Xmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/xmp/4.0.2/xmp-4.0.2.tar.gz'
  sha1 '32c2d5884cd94cfbc442095200d625b9f7ec6d2d'
  head 'git://git.code.sf.net/p/xmp/xmp-cli'

  depends_on :autoconf if build.head?
  depends_on 'libxmp'

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # install the included demo song
    share.install "08_sad_song.it" unless build.head?
  end

  def test
    system "#{bin}/xmp", "--load-only", share/"08_sad_song.it"
  end
end
