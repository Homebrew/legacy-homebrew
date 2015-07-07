class Writerperfect < Formula
  desc "Library for importing WordPerfect documents"
  homepage "http://sourceforge.net/p/libwpd/wiki/writerperfect/"
  url "https://downloads.sourceforge.net/project/libwpd/writerperfect/writerperfect-0.9.4/writerperfect-0.9.4.tar.xz"
  sha256 "6714bf945a657550eb84bd2f1f0b78b894f59536d8302942810134426f7a23ea"

  bottle do
    cellar :any
    sha256 "379df0c8b6577efa235b9e6aecf6ba66bdd5f0ca5d9ad62339569de6b33f2981" => :yosemite
    sha256 "434321af20c73e09c1aa0158b19e699050219d4b99e32b881b608540c77b74a1" => :mavericks
    sha256 "91b2eaa53277a6dd05330caa3e4342f11e65877b45c4bca3344c4dcc7abd7a9a" => :mountain_lion
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
