require 'formula'

class Openslide < Formula
  homepage 'http://openslide.org/'
  url 'https://github.com/openslide/openslide/releases/download/v3.4.0/openslide-3.4.0.tar.gz'
  sha1 'edd28a142f7801a354949c05e7f1b7dcb246db6b'

  bottle do
    cellar :any
    sha1 "f03b2209cd35a2b548b012210ea2e439c80b44d7" => :yosemite
    sha1 "5327cde1c873328b6b90f48a8400b569436323de" => :mavericks
    sha1 "ef49c02614e0ec8c2a0e5f71a6de309023a77a0c" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libpng'
  depends_on 'jpeg'
  depends_on 'libxml2'
  depends_on 'libtiff'
  depends_on 'glib'
  depends_on 'openjpeg'
  depends_on 'cairo'
  depends_on 'gdk-pixbuf'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
