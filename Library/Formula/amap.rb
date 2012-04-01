require 'formula'

class Amap < Formula
  homepage 'http://www.thc.org/thc-amap/'
  url 'http://www.thc.org/releases/amap-5.4.tar.gz'
  md5 '2617c13b0738455c0e61c6e980b8decc'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    # --prefix doesn't work as we want it to so install manually
    bin.install "amap", "amap6", "amapcrap"
    man1.install "amap.1"
  end
end
