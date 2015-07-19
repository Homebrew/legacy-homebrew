class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "http://ftpmirror.gnu.org/libextractor/libextractor-1.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libextractor/libextractor-1.3.tar.gz"
  sha256 "868ad64c9a056d6b923d451d746935bffb1ddf5d89c3eb4f67d786001a3f7b7f"

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
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match /Keywords for file/, shell_output("#{bin}/extract #{fixture}")
  end
end
