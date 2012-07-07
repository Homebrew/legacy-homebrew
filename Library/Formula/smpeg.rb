require 'formula'

class Smpeg < Formula
  homepage 'http://icculus.org/smpeg/'
  head 'svn://svn.icculus.org/smpeg/trunk'

  depends_on :automake
  depends_on :libtool

  depends_on 'pkg-config' => :build
  depends_on 'sdl'

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtktest",
                          "--disable-sdltest"
    system "make"
    # Install script is not +x by default for some reason
    system "chmod +x ./install-sh"
    system "make install"
  end
end
