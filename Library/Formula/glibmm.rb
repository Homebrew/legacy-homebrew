require 'formula'

class Glibmm < Formula
  homepage 'http://www.gtkmm.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glibmm/2.40/glibmm-2.40.0.tar.xz'
  sha256 '34f320fad7e0057c63863706caa802ae0051b21523bed91ec33baf8421ca484f'

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
