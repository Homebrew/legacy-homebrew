require 'formula'

class Libagg < Formula
  homepage 'http://www.antigrain.com'
  url 'http://www.antigrain.com/agg-2.5.tar.gz'
  sha1 '08f23da64da40b90184a0414369f450115cdb328'

  depends_on :automake
  depends_on :libtool
  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on :freetype => :optional

  fails_with :clang do
    cause <<-EOS.undent
      AGG tries to return a const reference as a non-const reference, which is
      rejected by clang 3.1 but accepted by gcc
    EOS
  end

  def install
    # AM_C_PROTOTYPES was removed in automake 1.12, as it's only needed for
    # pre-ANSI compilers
    inreplace 'configure.in', 'AM_C_PROTOTYPES', ''
    inreplace 'autogen.sh', 'libtoolize', 'glibtoolize'

    system "sh", "autogen.sh",
                 "--disable-dependency-tracking",
                 "--prefix=#{prefix}",
                 "--disable-platform", # Causes undefined symbols
                 "--disable-ctrl",     # No need to run these during configuration
                 "--disable-examples",
                 "--disable-sdltest"
    system "make install"
  end
end
