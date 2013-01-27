require 'formula'

class Xmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/xmp/3.5.0/xmp-3.5.0.tar.gz'
  sha1 '0707b586a445b4c3aab50eb1a6b9feb431a20983'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # install the included demo song
    share.install "SynthSong1"
  end

  def test
    system "#{bin}/xmp", "--load-only", "#{share}/SynthSong1"
  end
end
