class Libxmp < Formula
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.3.5/libxmp-4.3.5.tar.gz"
  sha1 "39a5cef59e537062ae109972de95783bc2f256ab"

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
