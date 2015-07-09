class Wdiff < Formula
  desc "Display word differences between text files"
  homepage "https://www.gnu.org/software/wdiff/"
  url "http://ftpmirror.gnu.org/wdiff/wdiff-1.2.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/wdiff/wdiff-1.2.2.tar.gz"
  sha256 "34ff698c870c87e6e47a838eeaaae729fa73349139fc8db12211d2a22b78af6b"

  depends_on "gettext" => :optional

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
