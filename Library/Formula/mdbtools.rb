require 'formula'

class Mdbtools <Formula
  homepage 'http://sourceforge.net/projects/mdbtools/'
  # Last stable release won't build on OS X, but HEAD from CVS does.
  head "cvs://:pserver:anonymous@mdbtools.cvs.sourceforge.net:/cvsroot/mdbtools:mdbtools"

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gawk' => :optional # To generate docs

  def install
    inreplace 'autogen.sh', 'libtool', 'glibtool'

    system "NOCONFIGURE='yes' ACLOCAL_FLAGS='-I#{HOMEBREW_PREFIX}/share/aclocal' ./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
