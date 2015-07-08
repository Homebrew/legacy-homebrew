require "formula"

class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "http://www.gnu.org/software/libextractor/"
  url "http://ftpmirror.gnu.org/libextractor/libextractor-1.3.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libextractor/libextractor-1.3.tar.gz"
  sha1 "613d0b80e83c79c3e05e073bcda0d0d0bd1f3336"

  bottle do
    cellar :any
    revision 1
    sha1 "8e3741386b03c28bc8c24e785f3882d277d416e1" => :yosemite
    sha1 "505b8c3cbbf23e91d80548dc2dd6011a1231a92e" => :mavericks
    sha1 "bb525c96875785d893080702ef010605424147db" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "iso-codes" => :optional

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
