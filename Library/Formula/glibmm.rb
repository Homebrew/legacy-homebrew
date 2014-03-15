require 'formula'

class Glibmm < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.38/glibmm-2.38.1.tar.xz'
  sha256 '49c925ee1d3c4d0d6cd7492d7173bd6826db51d0b55f458a6496406ae267c4a2'

  bottle do
    sha1 "b405d3bd887ab8268eafb7d01a7fcb32977a3f97" => :mavericks
    sha1 "e1b2dc92316aa3c162149987e15bc34806c05248" => :mountain_lion
    sha1 "a6155e561ab340ba24553ee953f74f917e7fca2c" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
