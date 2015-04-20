require 'formula'

class Ifuse < Formula
  homepage 'http://www.libimobiledevice.org/'
  url 'https://github.com/libimobiledevice/ifuse/archive/1.1.3.tar.gz'
  sha1 '447e9309fba1979be98ec83a4627b421dbd83032'
  bottle do
    cellar :any
    sha1 "36193691045028ec72dfde9b862b752a3e53ee2b" => :mavericks
    sha1 "9793481729e287f0a1b0e43bdcda489880d81a83" => :mountain_lion
  end

  revision 1

  head 'http://cgit.sukimashita.com/ifuse.git'

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "glib"
  depends_on "libimobiledevice"
  depends_on :osxfuse

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
