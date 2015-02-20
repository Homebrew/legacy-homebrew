class Libxmp < Formula
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.3.5/libxmp-4.3.5.tar.gz"
  sha1 "39a5cef59e537062ae109972de95783bc2f256ab"

  bottle do
    cellar :any
    sha1 "6c1d8e11eeed747b2c3eef68580242aa54fd534d" => :yosemite
    sha1 "95b085e5280cd384298f4076670b2c748dd57f14" => :mavericks
    sha1 "baa6fa4eb7e74e3212ede70e140c3ac535bd68c9" => :mountain_lion
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
