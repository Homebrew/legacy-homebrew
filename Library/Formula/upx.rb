class Upx < Formula
  homepage "http://upx.sourceforge.net"
  url "http://upx.sourceforge.net/download/upx-3.91-src.tar.bz2"
  sha1 "da962c0affb27eae11aa9b6fbd751c3699717b36"
  head "https://www.pysol.org:4443/hg/upx.hg", :using => :hg
  revision 1

  depends_on "ucl"

  resource "lzma" do
    url "https://downloads.sourceforge.net/project/sevenzip/LZMA%20SDK/lzma938.7z"
    sha1 "fe7e45f87b0635b453af920dfa15a8ad024b7e96"
  end

  def install
    inreplace "src/compress_lzma.cpp", "C/Types.h", "C/7zTypes.h"
    (buildpath/"lzmasdk").install resource("lzma")
    ENV["UPX_LZMADIR"] = buildpath/"lzmasdk"
    ENV["UPX_LZMA_VERSION"] = "0x938"
    system "make all"
    bin.install  "src/upx.out" => "upx"
    man1.install "doc/upx.1"
  end
end
