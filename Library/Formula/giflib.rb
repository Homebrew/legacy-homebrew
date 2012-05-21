require 'formula'

class Giflib < Formula
  homepage 'http://giflib.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/giflib/giflib-4.x/giflib-4.1.6/giflib-4.1.6.tar.bz2'
  md5 '7125644155ae6ad33dbc9fc15a14735f'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
