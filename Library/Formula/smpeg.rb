require 'formula'

class Smpeg < Formula
  homepage 'http://icculus.org/smpeg/'
  head 'svn://svn.icculus.org/smpeg/trunk'

  depends_on :automake
  depends_on :libtool
  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'gtk+'

  def install
    sdl = Formula.factory("sdl")
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest",
                          # For non-/usr/local installs
                          "--with-sdl-prefix=#{sdl.opt_prefix}"
    system "make"
    # Install script is not +x by default for some reason
    system "chmod +x ./install-sh"
    system "make install"
  end
end
