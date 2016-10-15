class Sniproxy < Formula
  homepage "https://github.com/dlundquist/sniproxy"
  head "https://github.com/dlundquist/sniproxy.git"
  url "https://github.com/dlundquist/sniproxy/archive/0.3.6.tar.gz"
  sha1 "f241bbbb12fff56896a58b85627aa01eeb914188"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libev"
  depends_on "pcre"
  depends_on "udns"
  depends_on "gettext"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
