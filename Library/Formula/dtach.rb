require 'formula'

class Dtach <Formula
  url 'http://downloads.sourceforge.net/project/dtach/dtach/0.8/dtach-0.8.tar.gz'
  homepage 'http://dtach.sourceforge.net/'
  md5 'ec5999f3b6bb67da19754fcb2e5221f3'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    
    # Does #include <config.h> instead of #include "config.h"
    # so it needs . in the include path.
    ENV.append "CFLAGS", "-I."

    # Use our own flags, thanks.
    inreplace "Makefile", /^CC = .*$/, ""
    inreplace "Makefile", /^CFLAGS = .*$/, ""
    inreplace "Makefile", /^LIBS = .*$/, ""
    
    system "make"
    bin.install "dtach"
  end
end
