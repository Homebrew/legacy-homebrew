class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "http://dev.yorhel.nl/ncdc"
  url "http://dev.yorhel.nl/download/ncdc-1.19.1.tar.gz"
  sha256 "a6b23381434a47f7134d9ebdf5658fd06768f9b5de498c43e0fa00d1c7229d47"

  bottle do
    cellar :any
    sha256 "ca94bbb642bde3040c7ff044416f1f4c317e987ec391a08d19e0eb3255cfe458" => :yosemite
    sha256 "2534b7f72747615d2eb9989a2ea4147312cb604c7723b3421155f7b0837e8e71" => :mavericks
    sha256 "1e362cd2a91f1a9a7bfe401e4665d33a8a35076097e8acb0153cadc67aea8b6c" => :mountain_lion
  end

  head do
    url "git://g.blicky.net/ncdc.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-geoip", "Build with geoip support"

  depends_on "glib"
  depends_on "sqlite"
  depends_on "gnutls" => "with-p11-kit"
  depends_on "pkg-config" => :build
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
