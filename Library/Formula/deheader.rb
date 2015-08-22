class Deheader < Formula
  desc "Analyze C/C++ files for unnecessary headers"
  homepage "http://www.catb.org/~esr/deheader"
  url "http://www.catb.org/~esr/deheader/deheader-1.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/d/deheader/deheader_1.2.orig.tar.gz"
  sha256 "c4e4a4af6f0707a2f8b10b10f3776674c589a569c3451dea978f2d0b76c71d12"
  head "https://gitlab.com/esr/deheader.git"

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
