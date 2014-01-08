require 'formula'

class Amap < Formula
  homepage 'http://www.thc.org/thc-amap/'
  url 'http://www.thc.org/releases/amap-5.4.tar.gz'
  sha1 '79056f29a3b9e0a21062116aec3e966b1a46d7d3'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    # --prefix doesn't work as we want it to so install manually
    bin.install "amap", "amap6", "amapcrap"
    man1.install "amap.1"
  end
end
