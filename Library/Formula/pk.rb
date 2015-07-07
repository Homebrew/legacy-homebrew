class Pk < Formula
  desc "Field extractor command-line utility"
  homepage "https://github.com/johnmorrow/pk"
  url "https://github.com/johnmorrow/pk/releases/download/v1.0.2/pk-1.0.2.tar.gz"
  sha256 "0431fe8fcbdfb3ac8ccfdef3d098d6397556f8905b7dec21bc15942a8fc5f110"

  depends_on "argp-standalone"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    assert_equal "B C D", pipe_output("#{bin}/pk 2..4", "A B C D E", 0).chomp
  end
end
