require 'formula'

class Omega < Formula
  url 'http://www.alcyone.com/binaries/omega/omega-0.80.2-src.tar.gz'
  homepage 'http://www.alcyone.com/max/projects/omega/'
  md5 '6d65ec9e0cc87ccf89ab491533ec4b77'

  def install
    # Set up our target folders
    inreplace "defs.h", "#define OMEGALIB \"./omegalib/\"", "#define OMEGALIB \"#{libexec}/\""

    # Don't alias CC; also, don't need that ncurses include path
    # Set the system type in CFLAGS, not in makefile
    # Remove an obsolete flag
    inreplace "Makefile" do |s|
      s.remove_make_var! ['CC', 'CFLAGS', 'LDFLAGS']
    end

    ENV.append_to_cflags "-DUNIX -DSYSV"

    system "make"

    # 'make install' is weird, so we do it ourselves
    bin.install "omega"
    libexec.install Dir['omegalib/*']
  end
end
