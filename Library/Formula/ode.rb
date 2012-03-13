require 'formula'

class Ode < Formula
  # Build from svn to get Snow Leopard fixes.
  url 'http://opende.svn.sourceforge.net/svnroot/opende/trunk', :revision => 1760
  version 'r1760'
  homepage 'http://www.ode.org/'
  head 'http://opende.svn.sourceforge.net/svnroot/opende/trunk'

  # find a proper tarball with configure and remove autogen and these deps
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.j1
    system "sh autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-demos"
    system "make"
    system "make install"
  end
end
