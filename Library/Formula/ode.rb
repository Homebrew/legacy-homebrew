require 'formula'

class Ode <Formula
  # Build from svn to get Snow Leopard fixes.
  url 'https://opende.svn.sourceforge.net/svnroot/opende/trunk', :revision => '1728'
  homepage 'http://www.ode.org/'

  def install
    ENV.j1
    # only necessary when downloading from svn
    system "sh autogen.sh" unless File.exist? "configure"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
