class Libdvdcss < Formula
  homepage "https://www.videolan.org/developers/libdvdcss.html"
  url "https://download.videolan.org/pub/videolan/libdvdcss/1.3.99/libdvdcss-1.3.99.tar.bz2"
  sha1 "4da6ae5962a837f47a915def2cd64e685ea72668"

  head do
    url "git://git.videolan.org/libdvdcss"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    revision 1
    sha1 "7709d75dbacced986314aba9c05f7e9351d9aeca" => :yosemite
    sha1 "dd85bca762d539179011f67a7196bd3a3392abac" => :mavericks
    sha1 "8d1e8dd357ac40b115c785e054041616b79a2d73" => :mountain_lion
  end

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
