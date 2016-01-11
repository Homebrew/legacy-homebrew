class Upx < Formula
  desc "Compress/expand executable files"
  homepage "http://upx.sourceforge.net"
  url "http://upx.sourceforge.net/download/upx-3.91-src.tar.bz2"
  mirror "https://fossies.org/linux/privat/upx-3.91-src.tar.bz2"
  sha256 "527ce757429841f51675352b1f9f6fc8ad97b18002080d7bf8672c466d8c6a3c"
  head "https://www.pysol.org:4443/hg/upx.hg", :using => :hg
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "be65bc79a7cb80800e933ac2a39d92fd60c26b8777fe7fe42c0aac0ca0a08d5b" => :el_capitan
    sha256 "e994574f32103ab5ddf4206093ac9733c66e59bac5e2d3104e56e90dc668e0fa" => :yosemite
    sha256 "88d59c54ca8f47a035e9a145a995b74589a9c4ed1524ff5ac91a7a7dbd34df11" => :mavericks
    sha256 "6e715e575ec208612d046de57438fe1568d3b56dc536db7935b2d421d1b0041c" => :mountain_lion
  end

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
