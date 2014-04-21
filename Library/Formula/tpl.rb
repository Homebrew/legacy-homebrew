require "formula"

class Tpl < Formula
  homepage "http://troydhanson.github.io/tpl/"
  url "https://github.com/troydhanson/tpl/archive/v1.6.1.tar.gz"
  sha1 "2ee92627e8f67400061d8fc606b601988ed90217"
  head "https://github.com/troydhanson/tpl.git"

  option "with-tests", "Verify the build using the test suite."

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    system "make", "-C", "tests" if build.with? "tests"
  end
end
