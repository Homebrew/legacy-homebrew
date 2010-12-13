require 'formula'

class Ungif < Formula
  url 'http://sourceforge.net/projects/giflib/files/libungif%204.x/libungif-4.1.4/libungif-4.1.4.tar.bz2'
  md5 '76865bc1bed90ecb5992a1edcc4d6c15'
  homepage 'http://sourceforge.net/projects/giflib/'

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}"
    system "make all"
    system "make install"
  end
end
