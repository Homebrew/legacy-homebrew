class Stklos < Formula
  homepage "http://www.stklos.net/"
  url "http://www.stklos.net/download/stklos-1.10.tar.gz"
  sha256 "215e6e6ffcf7751be5f0c114f83286f99e556e089ca1b0ee66f54dd1be080de4"

  depends_on "gmp"
  depends_on "pcre"
  depends_on "bdw-gc"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "42", shell_output("stklos -e '(print (+ 41 1))'").chomp
  end
end
