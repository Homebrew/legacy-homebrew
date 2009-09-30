require 'brewkit'

class Omega <Formula
  @url='http://www.alcyone.com/binaries/omega/omega-0.80.2-src.tar.gz'
  @homepage='http://www.alcyone.com/max/projects/omega/'
  @md5='6d65ec9e0cc87ccf89ab491533ec4b77'

  def install
    # 'make install' is weird, so we do it ourselves
    
    # Set up our target folders
    inreplace "defs.h", "#define OMEGALIB \"./omegalib/\"", "#define OMEGALIB \"#{libexec}/\""

    # Don't alias CC this way; also, don't need that ncurses include path
    inreplace "Makefile", "CC = gcc -I/usr/include/ncurses", ""

    # Set the system type in CFLAGS, not in makefile
    inreplace "Makefile", "CFLAGS = -DUNIX -DSYSV -O", ""
    ENV['CFLAGS'] = ENV['CFLAGS'] + " -DUNIX -DSYSV"

    # Remove an obsolete flag
    inreplace "Makefile", "LDFLAGS = -s", ""
    
    system "make"

    bin.install "omega"
    libexec.install Dir['omegalib/*']
  end
end
