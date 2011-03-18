require 'formula'

class Libdv < Formula
  url 'http://downloads.sourceforge.net/libdv/libdv-1.0.0.tar.gz'
  homepage 'http://libdv.sourceforge.net'
  md5 'f895162161cfa4bb4a94c070a7caa6c7'

  depends_on 'popt'

  def install
    # This fixes an undefined symbol error on compile.
    # See the port file for libdv. http://libdv.darwinports.com/
    # This flag is the prefered method over what macports uses.
    # See the apple docs: http://cl.ly/2HeF bottom of the "Finding Imported Symbols" section
    ENV.append "LDFLAGS", "-undefined dynamic_lookup"

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--disable-gtktest",
                          "--disable-gtk",
                          "--disable-asm",
                          "--disable-sdltest"
    system "make install"
  end
end
