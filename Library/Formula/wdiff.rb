class Wdiff < Formula
  desc "Display word differences between text files"
  homepage "https://www.gnu.org/software/wdiff/"
  url "http://ftpmirror.gnu.org/wdiff/wdiff-1.2.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/wdiff/wdiff-1.2.2.tar.gz"
  sha256 "34ff698c870c87e6e47a838eeaaae729fa73349139fc8db12211d2a22b78af6b"

  bottle do
    cellar :any
    sha256 "1e34ac95a5aa21146f93c5bd0d7d1b22c48941101dc684d019d6d9700da90e8f" => :yosemite
    sha256 "6cf8260aaa5f0da951bf405f3ed05e1660f8ca7d585c11324319b0c1e6371d56" => :mavericks
    sha256 "06da8b4a640ef51d0dd884b436d3909c4bd2c5c00ea5da9e81158554a00f0dbe" => :mountain_lion
  end

  depends_on "gettext" => :optional

  conflicts_with "montage", :because => "Both install an mdiff executable"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-experimental"
    system "make", "install"
  end

  test do
    a = testpath/"a.txt"
    a.write "The missing package manager for OS X"

    b = testpath/"b.txt"
    b.write "The package manager for OS X"

    output = shell_output("#{bin}/wdiff #{a} #{b}", 1)
    assert_equal "The [-missing-] package manager for OS X", output
  end
end
