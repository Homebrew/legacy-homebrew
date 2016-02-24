class CrushTools < Formula
  desc "Command-line tools for processing delimited text data"
  homepage "https://github.com/google/crush-tools"
  url "https://github.com/google/crush-tools/releases/download/20150716/crush-tools-20150716.tar.gz"
  sha256 "ef2f9c919536a2f13b3065af3a9a9756c90ede53ebd67d3e169c90ad7cd1fb05"

  bottle do
    cellar :any
    sha256 "0c7c58b9f2ec87237934eda55932b200c6d7b7f6dbb07a35e0a49ed389e984d3" => :el_capitan
    sha256 "90c901bd6daf8178407232c6b3be7f3c5056e9cf2ab88750d09b151e0973d4ff" => :yosemite
    sha256 "f1319787a7aafc6610f0217299791c428e5784d11cc93c8cd623e8a5cba5c414" => :mavericks
    sha256 "4fe244ac195a6051551f610c9435de7bf65beaa0b3c00ef5ff39945e9d2f3b3f" => :mountain_lion
  end

  head do
    url "https://github.com/google/crush-tools.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "aggregate", :because => "both install an `aggregate` binary"
  conflicts_with "num-utils", :because => "both install an `range` binary"

  depends_on "pcre"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "1 2 6 7 8 9 10", shell_output("#{bin}/range 1,2,6-10").strip
    assert_equal "o", shell_output("#{bin}/tochar 111")
  end
end
