require 'formula'

class Libagg < Formula
  homepage 'http://www.antigrain.com'
  url 'http://www.antigrain.com/agg-2.5.tar.gz'
  md5 '0229a488bc47be10a2fee6cf0b2febd6'

  depends_on 'pkg-config' => :build
  depends_on 'sdl'

  def install
    ENV.x11 # For freetype

    # No configure script. We need to run autoreconf, and aclocal and automake
    # need some direction.
    ENV['ACLOCAL'] = "/usr/bin/aclocal -I#{HOMEBREW_PREFIX}/share/aclocal" # To find SDL m4 files
    # This part snatched from MacPorts
    ENV['AUTOMAKE'] = "/usr/bin/automake --foreign --add-missing --ignore-deps"
    system "/usr/bin/autoreconf -fi"

    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--disable-platform", # Causes undefined symbols
           "--disable-ctrl",     # No need to run these during configuration
           "--disable-examples",
           "--disable-sdltest"

    system "make install"
  end
end
