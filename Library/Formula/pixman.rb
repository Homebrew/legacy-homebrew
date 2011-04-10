require 'formula'

class Pixman < Formula
  url 'http://cgit.freedesktop.org/pixman/snapshot/pixman-0.21.6.tar.bz2'
  homepage 'http://www.cairographics.org/'
  sha1 '7725825e3bdf3edbd00de8f4162c30d42387a8db'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gtk=no" # Don't need to build tests
    system "make install"
  end
end
