require 'formula'

class Exult <Formula
  # Use a specific revision that is known to compile (on Snow Leopard too.)
  head 'http://exult.svn.sourceforge.net/svnroot/exult/exult/trunk', :revision => '6128'
  homepage 'http://exult.sourceforge.net/'
  
  depends_on 'sdl'
  depends_on 'sdl_mixer'
  
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
    libexec.install "Exult.app"
  end
  
  def caveats
    "Cocoa app installed to #{libexec}\n\n"\
    "Note that this includes only the game engine; you will need to supply\n"\
    "your own legal copy of the Ultima 7 game files.\n\n"\
    "Try here:\n\thttp://www.amazon.com/gp/product/B0002SKOEC?ie=UTF8&tag=adamvandesper-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=B0002SKOEC"
  end
end
