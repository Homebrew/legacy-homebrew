class Tlsdate < Formula
  desc "Secure rdate replacement"
  homepage "https://www.github.com/ioerror/tlsdate/"
  head "https://github.com/ioerror/tlsdate.git"
  url "https://github.com/ioerror/tlsdate/archive/tlsdate-0.0.8.tar.gz"
  sha256 "65b2f8bd36556c7685916f7a783f3bec7b0712a012a6f34247a2fd5e8b410d17"
  revision 1

  bottle do
    sha256 "3cccdaaa4afef83888242af97c7d114c98bc0729abefc1f4f520c962be87db33" => :el_capitan
    sha256 "c904319078859012e71d74349fa5af1807bfa7ca2d768f3cc369c70d2ecefaa7" => :yosemite
    sha256 "7029cf53f6f9f1c6a7bd00a4a8e846bc9b0d3f18bbc86b147f03ef3814f324d1" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tlsdate", "--verbose", "--dont-set-clock"
  end
end
