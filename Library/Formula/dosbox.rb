require 'formula'
require 'hardware'

# Install script heavily borrowed from Fink package:
#  http://pdb.finkproject.org/pdb/package.php/dosbox
class Dosbox <Formula
  url 'http://downloads.sourceforge.net/project/dosbox/dosbox/0.73/dosbox-0.73.tar.gz'
  homepage 'http://www.dosbox.com/'
  md5 '0823a11242db711ac3d6ebfff6aff572'
  
  depends_on 'sdl'
  depends_on 'sdl_net'
  depends_on 'sdl_sound'
  
  def install
    ENV.libpng
    ENV.fast
    
    which_darwin=`uname -r|cut -f1 -d.`
    
    # 64-bit CPU detection is broken in ./configure
    if MACOS_VERSION >= 10.6 and Hardware.is_64_bit?
      which_cpu = 'x86_64'
    else
      which_cpu = 'i386'
    end
    
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-sdltest",
                          "--enable-core-inline",
                          "--build=#{which_cpu}-apple-darwin#{which_darwin}"
    
    # This should be a patch - add missing header.
    inreplace "src/gui/midi_coreaudio.h",
      "#include <AudioToolbox/AUGraph.h>",
      "#include <AudioToolbox/AUGraph.h>\n#include <CoreServices/CoreServices.h>"
    
    system "make"
    
    bin.install 'src/dosbox'
    man1.install gzip('docs/dosbox.1')
  end
end
