require "formula"

class Netdiscover < Formula
  homepage "http://nixgeneration.com/~jaime/netdiscover/"
  url "http://nixgeneration.com/~jaime/netdiscover/releases/netdiscover-0.3-beta6.tar.gz"
  sha1 "b6dfb89a0cbd14e398ae01f358bc56719c994856"

  head "https://netdiscover.svn.sourceforge.net/svnroot/netdiscover/trunk"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  def install
    system "./autogen.sh" if build.head?
    system "autoconf" if !build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
