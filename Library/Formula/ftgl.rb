class Ftgl < Formula
  desc "Freetype / OpenGL bridge"
  homepage "http://sourceforge.net/projects/ftgl/"
  url "https://downloads.sourceforge.net/project/ftgl/FTGL%20Source/2.1.3~rc5/ftgl-2.1.3-rc5.tar.gz"
  sha256 "5458d62122454869572d39f8aa85745fc05d5518001bcefa63bd6cbb8d26565b"

  depends_on "freetype"

  def install
    # If doxygen is installed, the docs may still fail to build.
    # So we disable building docs.
    inreplace "configure", "set dummy doxygen;", "set dummy no_doxygen;"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-freetypetest",
                          # Skip building the example program by failing to find GLUT (MacPorts)
                          "--with-glut-inc=/dev/null",
                          "--with-glut-lib=/dev/null"

    system "make", "install"
  end
end
