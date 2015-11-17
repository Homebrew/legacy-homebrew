class Potrace < Formula
  desc "Convert bitmaps to vector graphics"
  homepage "http://potrace.sourceforge.net"
  url "http://potrace.sourceforge.net/download/1.12/potrace-1.12.tar.gz"
  sha256 "b0bbf1d7badbebfcb992280f038936281b47ddbae212e8ae91e863ce0b76173b"

  bottle do
    cellar :any
    sha256 "6144f8258b0fe5d64105c1f595927acbe80d214c8a895d4fa8712c487440cfc3" => :el_capitan
    sha256 "c9141e2c9d92ba0c3a756de14847460d912a4fe4fac3a43031e43fda61337fbb" => :yosemite
    sha256 "9a3f518d257b71a24f392fe3fa2602c6d0c83930cdb2595088c4478bb07d27e9" => :mavericks
    sha256 "646426083e81564f2345d173b493f99e356c29b23947e1f1ccfec932bfa14d97" => :mountain_lion
  end

  resource "head.pbm" do
    url "http://potrace.sourceforge.net/img/head.pbm"
    sha256 "3c8dd6643b43cf006b30a7a5ee9604efab82faa40ac7fbf31d8b907b8814814f"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libpotrace"
    system "make", "install"
  end

  test do
    resource("head.pbm").stage testpath
    system "#{bin}/potrace", "-o", "test.eps", "head.pbm"
    assert File.exist? "test.eps"
  end
end
