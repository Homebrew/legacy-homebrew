class Loudmouth < Formula
  desc "Lightweight C library for the Jabber protocol"
  homepage "https://mcabber.com"
  url "https://mcabber.com/files/loudmouth/loudmouth-1.5.1.tar.bz2"
  sha256 "ffb493b085c1d40176ecbe1c478f05932f265e0e5ba93444b87d3cd076267939"
  revision 1

  bottle do
    cellar :any
    sha256 "b1cc2d6af15d37cb3317a52d8a82422cd071c3ae4efe93353f75cdba83a20723" => :el_capitan
    sha256 "1f5d182146487152aa2b20b7cf998b1ed57da9f0c5f9830fb2a316afcbaa48f7" => :yosemite
    sha256 "50967fd422f40a3b911205cb4dfdac27038120c1e860646621dc7343f07c231b" => :mavericks
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
