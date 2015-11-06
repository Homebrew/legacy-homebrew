class Loudmouth < Formula
  desc "Lightweight C library for the Jabber protocol"
  homepage "https://mcabber.com"
  url "https://mcabber.com/files/loudmouth/loudmouth-1.5.1.tar.bz2"
  sha256 "ffb493b085c1d40176ecbe1c478f05932f265e0e5ba93444b87d3cd076267939"

  bottle do
    cellar :any
    revision 1
    sha256 "94b43d775245f39b1b5e8e3042a3a9a6b5bda283eb9388f6ba7584e768440ed2" => :el_capitan
    sha256 "de555085936f17c58982b18b54ce5e033255453db378f7475d1aaed86402f58b" => :yosemite
    sha256 "0f790d8960e14b3d1df6de783acf19faaf3dedf95aea8a65cd99490ff115f71b" => :mavericks
  end

  head do
    url "https://github.com/mcabber/loudmouth.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libidn"
  depends_on "gnutls"

  def install
    system "./autogen.sh", "-n" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ssl=gnutls"
    system "make", "install"
  end
end
