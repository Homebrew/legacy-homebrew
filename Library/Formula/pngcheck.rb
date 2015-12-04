class Pngcheck < Formula
  desc "Print info and check PNG, JNG, and MNG files"
  homepage "http://www.libpng.org/pub/png/apps/pngcheck.html"
  url "https://downloads.sourceforge.net/project/png-mng/pngcheck/2.3.0/pngcheck-2.3.0.tar.gz"
  sha256 "77f0a039ac64df55fbd06af6f872fdbad4f639d009bbb5cd5cbe4db25690f35f"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "98e0a49125511f279c09c99fdb33ea5e2d44f489be4a8a6d70ce9faba48e8b92" => :el_capitan
    sha256 "2f8901f0259f2ec24478268e5fa4cd8fe904a160592f118efdddf4ba20221dd6" => :yosemite
    sha256 "af2af2a3771b7730c0da6fe3c74f6044b3664498c0b9f5070be3cf4d7ec1274e" => :mavericks
    sha256 "b4ebae530dd4e2cb7822f15c9da98cbfe6dd62540b222c6a85f297e446f67d66" => :mountain_lion
  end

  def install
    system "make", "-f", "Makefile.unx", "ZINC=", "ZLIB=-lz"
    bin.install %w[pngcheck pngsplit png-fix-IDAT-windowsize]
  end

  test do
    system bin/"pngcheck", test_fixtures("test.png")
  end
end
