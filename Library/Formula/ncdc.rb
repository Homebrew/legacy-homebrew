class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "https://dev.yorhel.nl/ncdc"
  url "https://dev.yorhel.nl/download/ncdc-1.19.1.tar.gz"
  sha256 "a6b23381434a47f7134d9ebdf5658fd06768f9b5de498c43e0fa00d1c7229d47"
  revision 1

  bottle do
    cellar :any
    revision 2
    sha256 "7cc72689567f3cee75a51f3b9b5a969252ff2ed87c94bf11fa761bee5519a8d0" => :el_capitan
    sha256 "fe636cd7cab6c7222bbbe05e499fdf2e0918bf55eeb96d64a070d13c7e5e7bd9" => :yosemite
    sha256 "903e7a502efff29bb8c5beac6dd249b99306fce915d66c0306fde008fc655b64" => :mavericks
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
