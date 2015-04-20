require 'formula'

class Libgnomecanvasmm < Formula
  homepage 'https://launchpad.net/libgnomecanvasmm'
  url 'http://ftp.gnome.org/pub/gnome/sources/libgnomecanvasmm/2.26/libgnomecanvasmm-2.26.0.tar.bz2'
  sha1 'c2f20c75f6eedbaf4a3299e0e3fda2ef775092e8'

  bottle do
    cellar :any
    revision 1
    sha1 "55adaa50f257add1c5b6660df1c0423a37f6d730" => :yosemite
    sha1 "55ef92e8c51a6421a844e138e007cae15d0b9e0d" => :mavericks
    sha1 "dcf3306ac9ab19171a2c3d05151fb8f020b96b4e" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libgnomecanvas'
  depends_on 'gtkmm'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
