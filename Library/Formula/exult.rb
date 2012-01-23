require 'formula'

class Exult < Formula
  url 'https://downloads.sourceforge.net/project/exult/exult-all-versions/1.4.9rc1/exult-1.4.9rc1.tar.gz'
  md5 'c17a48cc0377aa67264aaaf441cb1bb2'
  homepage 'http://exult.sourceforge.net/'

  head 'http://exult.svn.sourceforge.net/svnroot/exult/exult/trunk'

  depends_on 'sdl'
  depends_on 'sdl_mixer'
  depends_on 'libvorbis'

  def install
    inreplace "autogen.sh", "libtoolize", "glibtoolize"

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"

    system "make"
    system "make bundle"
    prefix.install "Exult.app"
  end

  def caveats; <<-EOS.undent
    Cocoa app installed to:
      #{prefix}

    Note that this includes only the game engine; you will need to supply your own
    own legal copy of the Ultima 7 game files. Try here (Amazon.com):
      http://bit.ly/8JzovU
    EOS
  end
end
