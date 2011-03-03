require 'formula'

class Ftgl <Formula
  url 'http://downloads.sourceforge.net/project/ftgl/FTGL%20Source/2.1.3~rc5/ftgl-2.1.3-rc5.tar.gz'
  homepage 'http://sourceforge.net/projects/ftgl/'
  md5 'fcf4d0567b7de9875d4e99a9f7423633'

  depends_on 'pkg-config' => :build

  def install
    ENV.x11 # Put freetype-config in path

    # If doxygen is installed, the docs may still fail to build.
    # So we disable building docs.
    inreplace "configure", "set dummy doxygen;", "set dummy no_doxygen;"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-freetypetest",
    # Skip building the example program by failing to find GLUT (MacPorts)
                          "--with-glut-inc=/dev/null",
                          "--with-glut-lib=/dev/null"

    # Hack the package info
    inreplace "ftgl.pc", "Requires.private: freetype2\n", ""

    system "make install"
  end
end
