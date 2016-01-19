class Ncdc < Formula
  desc "NCurses direct connect"
  homepage "https://dev.yorhel.nl/ncdc"
  url "https://dev.yorhel.nl/download/ncdc-1.19.1.tar.gz"
  sha256 "a6b23381434a47f7134d9ebdf5658fd06768f9b5de498c43e0fa00d1c7229d47"
  revision 1

  bottle do
    cellar :any
    sha256 "7005cc775a8d1aeeaab80561459b2ef228496bd563f731b0e320ecdeaaca2345" => :el_capitan
    sha256 "f4a58fb7b8300463979e6548a6483956b791dd9bd1d9293b9a629e6942563ccd" => :yosemite
    sha256 "65441ec1a2911ca9d362288a9ba9c21257597ef1c1d8bc4c0f00a2790b0ec2e5" => :mavericks
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
