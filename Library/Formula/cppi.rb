class Cppi < Formula
  homepage "https://www.gnu.org/software/cppi/"
  url "http://ftpmirror.gnu.org/cppi/cppi-1.18.tar.xz"
  mirror "https://ftp.gnu.org/cppi/cppi-1.18.tar.xz"
  sha256 "12a505b98863f6c5cf1f749f9080be3b42b3eac5a35b59630e67bea7241364ca"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    test = <<-EOS.undent
      #ifdef TEST
      #include <homebrew.h>
      #endif
    EOS
    assert_equal <<-EOS.undent, pipe_output("#{bin}/cppi", test, 0)
      #ifdef TEST
      # include <homebrew.h>
      #endif
    EOS
  end
end
