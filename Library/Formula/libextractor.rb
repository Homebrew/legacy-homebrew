require "formula"

class Libextractor < Formula
  homepage "http://www.gnu.org/software/libextractor/"
  url "http://ftpmirror.gnu.org/libextractor/libextractor-1.3.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libextractor/libextractor-1.3.tar.gz"
  sha1 "613d0b80e83c79c3e05e073bcda0d0d0bd1f3336"

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "iso-codes" => :optional

  conflicts_with "sptk", :because => "both install `extract`"

  def install
    ENV.deparallelize
    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/extract", "-v"
  end
end
