require 'formula'

class Ogmtools < Formula
  homepage 'http://www.bunkus.org/videotools/ogmtools/'
  url 'http://www.bunkus.org/videotools/ogmtools/ogmtools-1.5.tar.bz2'
  sha1 'a23ba7e6ac490ffb60e8fb739e790b7a020a444c'

  depends_on 'libogg'
  depends_on 'libvorbis'
  depends_on 'libdvdread' => :optional

  # Borrow patch from MacPorts
  def patches
    {:p0 => [
     'https://trac.macports.org/export/87593/trunk/dports/multimedia/ogmtools/files/common.h.diff'
    ]}
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  # Borrow warning from MacPorts
  def caveats; <<-EOS.undent
    Ogmtools has not been updated since 2004 and is no longer being developed,
    maintained or supported. There are several issues, especially on 64-bit
    architectures, which the author will not fix or accept patches for.
    Keep this in mind when deciding whether to use this software.
    EOS
  end
end
