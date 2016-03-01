class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "https://dev.yorhel.nl/ncdc"
  url "https://dev.yorhel.nl/download/ncdc-1.19.1.tar.gz"
  sha256 "a6b23381434a47f7134d9ebdf5658fd06768f9b5de498c43e0fa00d1c7229d47"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "f7feefe3718e9c3a05ce79f2041dc32bfee134bd8814441add9619be68bf4e80" => :el_capitan
    sha256 "1ef7784bd2c40aa5e20c9fd125bf9707dbebd2af6c8df82587d5831ba8f089a8" => :yosemite
    sha256 "1446fb4a72a5af8abc839e6b8e2e4ccbf53fbb95f0ff005ccdc36045965210d6" => :mavericks
  end

  head do
    url "https://g.blicky.net/ncdc.git", :shallow => false

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
      "--prefix=#{prefix}",
    ]
    args << "--with-geoip" if build.with? "geoip"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/ncdc", "-v"
  end
end
