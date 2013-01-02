require 'formula'

class Theora < Formula
  url 'http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2'
  homepage 'http://www.theora.org/'
  sha1 '8dcaa8e61cd86eb1244467c0b64b9ddac04ae262'

  depends_on 'pkg-config' => :build
  depends_on 'libogg'
  depends_on 'libvorbis'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
