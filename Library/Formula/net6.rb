class Net6 < Formula
  desc "C++ library for network-based applications"
  homepage "http://gobby.0x539.de"
  url "http://releases.0x539.de/net6/net6-1.3.14.tar.gz"
  sha256 "155dd82cbe1f8354205c79ab2bb54af4957047422250482596a34b0e0cc61e21"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libsigc++"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
