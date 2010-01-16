require 'formula'

# TODO we shouldn't be installing .apps if there is an option

class Exult <Formula
  # Use a specific revision that is known to compile (on Snow Leopard too.)
  head 'http://exult.svn.sourceforge.net/svnroot/exult/exult/trunk', :revision => '6128'
  homepage 'http://exult.sourceforge.net/'
  
  depends_on 'sdl'
  depends_on 'sdl_mixer'
  
  aka 'ultima7'
  
  def install
    # Yes, really. Goddamnit.
    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-sdltest"
                          
    system "make"
    system "make bundle"
    prefix.install "Exult.app"
  end
  
  def caveats;
    "Cocoa app installed to #{prefix}\n\n"\
    "Note that this includes only the game engine; you will need to supply your own\n"\
    "own legal copy of the Ultima 7 game files. Try here (Amazon.com):\n\n"\
    "http://bit.ly/8JzovU"
  end
end
