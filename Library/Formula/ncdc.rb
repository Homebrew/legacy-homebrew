class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "https://dev.yorhel.nl/ncdc"
  url "https://dev.yorhel.nl/download/ncdc-1.19.1.tar.gz"
  sha256 "a6b23381434a47f7134d9ebdf5658fd06768f9b5de498c43e0fa00d1c7229d47"

  bottle do
    cellar :any
    revision 1
    sha256 "a15ee5c1e7452253bfef3e8b24514bfea050420a253ab99a194598e0de62ca9d" => :el_capitan
    sha256 "0114ff829d45b411ba430be3c0021dda3eb58a2353b7111d30b86cd07a383413" => :yosemite
    sha256 "65e73f6cad014f4828295602c9e19094b17d8cdcad19df05e6cf136ee42b8721" => :mavericks
  end

  head do
    url "git://g.blicky.net/ncdc.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-geoip", "Build with geoip support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "sqlite"
  depends_on "gnutls"
  depends_on "geoip" => :optional

  def install
    system "autoreconf", "-ivf" if build.head?

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    ]
    args << "--with-geoip" if build.with? "geoip"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/ncdc", "-v"
  end
end
