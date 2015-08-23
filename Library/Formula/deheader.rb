class Deheader < Formula
  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader"
  url "http://www.catb.org/~esr/deheader/deheader-1.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/d/deheader/deheader_1.2.orig.tar.gz"
  sha256 "c4e4a4af6f0707a2f8b10b10f3776674c589a569c3451dea978f2d0b76c71d12"
  head "https://gitlab.com/esr/deheader.git"

  bottle do
    cellar :any
    sha256 "f5639a19b49fa7d603a2d41b2fc143342fe757b1e6c81f3ce316e93fc05a6d97" => :yosemite
    sha256 "19f3da5c021391bdf55276bbfadaf52459dceb8e591a6ea051d88c02bc1da93e" => :mavericks
    sha256 "a2bf7da66e79643bb3dbb0ec6a37a54d8d9436885d3a8c59d13e812050dcc8e5" => :mountain_lion
  end

  depends_on "xmlto" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "make"
    bin.install "deheader"
    man1.install "deheader.1"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <string.h>
      int main(void) {
        printf("%s", "foo");
        return 0;
      }
    EOS
    assert_equal "121", shell_output("deheader test.c | tr -cd 0-9")
  end
end
