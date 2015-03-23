class Libxmp < Formula
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.3.6/libxmp-4.3.6.tar.gz"
  sha256 "9894456dd3a8cea9b77de084c29f7cbb6ec16fd4d0005389913e8b205c02b750"

  bottle do
    cellar :any
    sha1 "85c1057afe6522dbebb969797de228fce7a632af" => :yosemite
    sha1 "c8c4ee4ec7b67956b0763e4e45374326388409f3" => :mavericks
    sha1 "540c03fb428d8596239d8d2c9394dbce1d0defaf" => :mountain_lion
  end

  head do
    url "git://git.code.sf.net/p/xmp/libxmp"
    depends_on "autoconf" => :build
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
