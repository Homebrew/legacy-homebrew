require 'formula'

class Sdcv < Formula
  homepage 'http://sdcv.sourceforge.net/'
  # MacPorts uses this revision and version number
  url 'https://sdcv.svn.sourceforge.net/svnroot/sdcv/trunk', :revision => '38'
  version '0.4.3'

  # Always needs a newer autotools, even on Snow Leopard.
  depends_on 'automake' => :build
  depends_on 'autoconf' => :build
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'readline'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      In C++, clang supports variable length arrays in very limited
      circumstances, the element type of a variable length array must
      be a POD ("plain old data") type.
      More detail here: http://clang.llvm.org/compatibility.html
      EOS
  end

  def patches
    { :p0 =>
      "https://trac.macports.org/export/100327/trunk/dports/textproc/sdcv/files/patch-setlocale.diff"
    }
  end

  def install
    # Compatibility with Automake 1.13+
    inreplace 'configure.ac', 'AM_CONFIG_HEADER', 'AC_CONFIG_HEADERS'
    system "autoreconf -vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
