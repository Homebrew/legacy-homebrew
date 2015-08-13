class CrushTools < Formula
  desc "Command-line tools for processing delimited text data"
  homepage "https://github.com/google/crush-tools"
  url "https://github.com/google/crush-tools/releases/download/20150716/crush-tools-20150716.tar.gz"
  sha256 "ef2f9c919536a2f13b3065af3a9a9756c90ede53ebd67d3e169c90ad7cd1fb05"

  head do
    url "https://github.com/google/crush-tools.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "aggregate", :because => "both install an `aggregate` binary"

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
