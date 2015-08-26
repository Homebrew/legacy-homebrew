class Tlsdate < Formula
  desc "Secure rdate replacement"
  homepage "https://www.github.com/ioerror/tlsdate/"
  head "https://github.com/ioerror/tlsdate.git"
  url "https://github.com/ioerror/tlsdate/archive/tlsdate-0.0.8.tar.gz"
  sha256 "65b2f8bd36556c7685916f7a783f3bec7b0712a012a6f34247a2fd5e8b410d17"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tlsdate", "--verbose", "--dont-set-clock"
  end
end
