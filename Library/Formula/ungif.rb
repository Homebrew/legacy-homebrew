require 'formula'

class Ungif < Formula
  url 'http://sourceforge.net/projects/giflib/files/libungif%204.x/libungif-4.1.4/libungif-4.1.4.tar.bz2'
  version '4.1.4'
  md5 '76865bc1bed90ecb5992a1edcc4d6c15'
  homepage 'http://sourceforge.net/projects/giflib/'
  def install
    # does not build with universal_binary engaged
    # ENV.universal_binary
    system "./configure", "--prefix=#{prefix}"
    system "make all"
    # their install system is screwed up
    # mkdir: /usr/local/Cellar/ungif/4.1.4/bin: File exists
    # so we call this twice
    system "make -k install"
    system "make install"
  end
end
