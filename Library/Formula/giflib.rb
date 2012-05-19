require 'formula'

class Giflib < Formula
  homepage 'http://giflib.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/giflib/giflib-4.x/giflib-4.2.0.tar.bz2'
  sha1 'bc942711f75de7d8539f79be34d69c0d53c381c1'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
