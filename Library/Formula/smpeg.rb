require 'formula'

class Smpeg < Formula
  head 'svn://svn.icculus.org/smpeg/trunk'
  homepage 'http://icculus.org/smpeg/'

  depends_on 'pkg-config' => :build
  depends_on 'sdl'

  if MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
