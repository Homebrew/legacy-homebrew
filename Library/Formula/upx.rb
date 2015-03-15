class Upx < Formula
  homepage "http://upx.sourceforge.net"
  url "http://upx.sourceforge.net/download/upx-3.91-src.tar.bz2"
  sha256 "527ce757429841f51675352b1f9f6fc8ad97b18002080d7bf8672c466d8c6a3c"
  head "https://www.pysol.org:4443/hg/upx.hg", :using => :hg
  revision 1

  depends_on "ucl"

  resource "lzma" do
    url "https://downloads.sourceforge.net/project/sevenzip/LZMA%20SDK/lzma938.7z"
    sha256 "721f4f15378e836686483811d7ea1282463e3dec1932722e1010d3102c5c3b20"
  end

  def install
    inreplace "src/compress_lzma.cpp", "C/Types.h", "C/7zTypes.h"
    (buildpath/"lzmasdk").install resource("lzma")
    ENV["UPX_LZMADIR"] = buildpath/"lzmasdk"
    ENV["UPX_LZMA_VERSION"] = "0x938"
    system "make", "all"
    bin.install "src/upx.out" => "upx"
    man1.install "doc/upx.1"
  end
  test do
    (testpath/"hello-c.c").write <<-EOS.undent
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "cc", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`

    system "#{bin}/upx", "-1", "hello-c"
    assert_equal "Hello, world!\n", `./hello-c`

    system "#{bin}/upx", "-d", "hello-c"
    assert_equal "Hello, world!\n", `./hello-c`
  end
end
