class Loudmouth < Formula
  desc "Lightweight C library for the Jabber protocol"
  homepage "https://mcabber.com"
  url "https://mcabber.com/files/loudmouth/loudmouth-1.5.1.tar.bz2"
  sha256 "ffb493b085c1d40176ecbe1c478f05932f265e0e5ba93444b87d3cd076267939"

  bottle do
    cellar :any
    sha256 "932085ed7ada3a634f1d5a1b6ff31443f07ce45447d0dbeb374855f4b3bc476f" => :el_capitan
    sha256 "4693898be18e03b7246e505430117ea6aece18b76dc0c4b494083aa4428dbbc8" => :yosemite
    sha256 "1474fdc11929e10e2fe67d7a4722c3f4aa9b30ae29a25faaea53045cc4edb8b4" => :mavericks
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
