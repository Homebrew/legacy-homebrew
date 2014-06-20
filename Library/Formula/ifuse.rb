require 'formula'

class Ifuse < Formula
  homepage 'http://www.libimobiledevice.org/'
  url 'https://github.com/libimobiledevice/ifuse/archive/1.1.3.tar.gz'
  sha1 '447e9309fba1979be98ec83a4627b421dbd83032'

  head 'http://cgit.sukimashita.com/ifuse.git'

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "glib"
  depends_on "libimobiledevice"
  depends_on "osxfuse"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
