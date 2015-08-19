class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "http://ftpmirror.gnu.org/libextractor/libextractor-1.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libextractor/libextractor-1.3.tar.gz"
  sha256 "868ad64c9a056d6b923d451d746935bffb1ddf5d89c3eb4f67d786001a3f7b7f"

  bottle do
    cellar :any
    revision 2
    sha256 "8bc531741c401c62dffaef0a29547d80b254eeb9dfd847d125b66c91dbcfc22b" => :yosemite
    sha256 "b725cac753d996850f3584650a04cd7ab7070ec6772d826ff251457b4c778bc4" => :mavericks
    sha256 "e26a107ce3e93be06cc6ac89d5edee8c6e18ff799e2198d762f81d524b3ce9ec" => :mountain_lion
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
