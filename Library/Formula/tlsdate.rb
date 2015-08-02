require "formula"

class Tlsdate < Formula
  desc "Secure rdate replacement"
  homepage "https://www.github.com/ioerror/tlsdate/"
  head "https://github.com/ioerror/tlsdate.git"
  url "https://github.com/ioerror/tlsdate/archive/tlsdate-0.0.8.tar.gz"
  sha1 "9de7c712ba21b61b06c130fe0e68fd6fdd3ab4aa"

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
