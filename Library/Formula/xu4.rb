require 'brewkit'

# See src/doc/xu4MacOSXcvs.txt in the tarball for some explanation
class Xu4 <Formula
  url 'http://downloads.sourceforge.net/project/xu4/xu4/1.0beta3/xu4-1.0beta3.tar.gz'
  homepage 'http://xu4.sourceforge.net/'
  md5 'fa1abc27a2e77496109531bffc8cfe2b'
  version '1.0beta3'
  
  depends_on 'sdl'
  depends_on 'sdl_mixer'

  def install
    ENV.libpng
    
    # Download the resource zips
    system "curl http://softlayer.dl.sourceforge.net/project/xu4/Ultima%20IV%20for%20DOS/1.01/ultima4-1.01.zip -O"
    system "curl http://softlayer.dl.sourceforge.net/project/xu4/Ultima%204%20VGA%20Upgrade/1.3/u4upgrad.zip -O"
    
    Dir.chdir 'src' do
      # Get the SDL prefix...
      sdl_prefix=(`sdl-config --prefix`).strip

      # ...so we can copy the ObjC main files.
      `cp -R #{sdl_prefix}/libexec/* macosx`
      
      # Use whatever compilers we want...
      inreplace "Makefile.macosx", "CC=gcc", ""
      inreplace "Makefile.macosx", "CXX=g++", ""
      
      # ...but fix an error from gcc >= 4.1
      inreplace "imagemgr.h", 
        "SubImage *ImageMgr::getSubImage(const std::string &name);",
        "SubImage *getSubImage(const std::string &name);"
      
      # Set our prefix
      # I don't think this is actually used in the mac build --adamv
      inreplace "Makefile", "prefix=/usr/local", "prefix=#{prefix}"
      
      # Use libpng from the system X11 folder
      # These next 2 replaces are pointless but
      # I don't want to break the syntax of the Makefile
      # by leaving it with trailing \ continuations.
      inreplace "Makefile.macosx",
        "LIBPNGDIR=../../libpng", "LIBPNGDIR=/usr/X11/lib"
        
      inreplace "Makefile.macosx",
        "-I$(LIBPNGDIR)", "-I/usr/X11/include"
        
      # Use X11 provided libpng
      inreplace "Makefile.macosx",
        "$(LIBPNGDIR)/libpng.a", "-lpng"
      
      # Too bad xu4 doesn't just do #include <SDL/SDL.h>
      # Slot in the SDL include path
      inreplace "Makefile.macosx",
        "-I/Library/Frameworks/SDL.framework/Headers",
        "-I#{sdl_prefix}/include/SDL"
        
      # Use "lib" versions of SDL, not Frameworks
      inreplace "Makefile.macosx",
        "-framework SDL", "-lSDL"
        
      inreplace "Makefile.macosx",
        "-framework SDL_mixer", "-lSDL_mixer"

      # Fix the u4 zip location
      inreplace "Makefile.macosx", "../../ultima4.zip", "../ultima4-1.01.zip"
      inreplace "Makefile.macosx", "../../u4upgrad.zip", "../u4upgrad.zip"
      
      # Build the .app right in the source tree; we've moving it later anyway
      inreplace "Makefile.macosx",
        "BUNDLE_CONTENTS=../../xu4.app/Contents",
        "BUNDLE_CONTENTS=xu4.app/Contents"

      system "make -f Makefile.macosx"
      system "make -f Makefile.macosx install"
      
      # Move the completed app bundle
      libexec.install "xu4.app"
    end
  end
  
  def caveats
    "xu4.app installed to #{libexec}"
  end
end
