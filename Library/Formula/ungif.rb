require 'formula'

class Ungif < Formula
  homepage 'http://sourceforge.net/projects/giflib/'
  url 'http://downloads.sourceforge.net/project/giflib/giflib%204.x/giflib-4.1.6/giflib-4.1.6.tar.bz2'
  md5 '7125644155ae6ad33dbc9fc15a14735f'

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}"
    system "make all"
    system "make install"
  end
end
