require 'formula'

class Ode < Formula
  # Build from svn to get Snow Leopard fixes.
  url 'http://opende.svn.sourceforge.net/svnroot/opende/trunk', :revision => 1760
  version 'r1760'
  homepage 'http://www.ode.org/'
  head 'http://opende.svn.sourceforge.net/svnroot/opende/trunk'

  def install
    ENV.j1
    # only necessary when downloading from svn
    system "sh autogen.sh" unless File.exist? "configure"
    system "./configure", "--prefix=#{prefix}", "--disable-demos"
    system "make"
    system "make install"
  end
end
