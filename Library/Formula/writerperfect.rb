class Writerperfect < Formula
  homepage "http://sourceforge.net/p/libwpd/wiki/writerperfect/"
  url "https://downloads.sourceforge.net/project/libwpd/writerperfect/writerperfect-0.9.4/writerperfect-0.9.4.tar.xz"
  sha256 "6714bf945a657550eb84bd2f1f0b78b894f59536d8302942810134426f7a23ea"

  bottle do
    cellar :any
    sha1 "2c0b127d6a3488421ba9179f0f1642fb360a141c" => :yosemite
    sha1 "7967b8d4de65dc7bc0add679975b7b546b4b838b" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libodfgen"
  depends_on "libwps"
  depends_on "libwpg"
  depends_on "libwpd"
  depends_on "libetonyek" => :optional
  depends_on "libvisio" => :optional
  depends_on "libmspub" => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
