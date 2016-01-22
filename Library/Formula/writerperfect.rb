class Writerperfect < Formula
  desc "Library for importing WordPerfect documents"
  homepage "https://sourceforge.net/p/libwpd/wiki/writerperfect/"
  url "https://downloads.sourceforge.net/project/libwpd/writerperfect/writerperfect-0.9.4/writerperfect-0.9.4.tar.xz"
  sha256 "6714bf945a657550eb84bd2f1f0b78b894f59536d8302942810134426f7a23ea"

  bottle do
    cellar :any
    revision 1
    sha256 "1600134e1f9b4be0d583572f69b5bd7ca8b6e8eae947c84f21cda375a9cac07c" => :el_capitan
    sha256 "832d945ab3a72c274f36e1d0fb8bfc8562f67cfbbea748c0ae9b4ab0189be633" => :yosemite
    sha256 "493d845cf744cb49fc750fc0cb304dd647b882d3bf01a3dd88791f2fb295fe9a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libmwaw" => :optional
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
