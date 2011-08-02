require 'formula'

# Dvdauthor will optionally detect ImageMagick or GraphicsMagick, too.
# But we don't add either as deps because they are big.

class Dvdauthor < Formula
  url 'http://downloads.sourceforge.net/project/dvdauthor/dvdauthor/0.7.0/dvdauthor-0.7.0.tar.gz'
  homepage 'http://dvdauthor.sourceforge.net/'
  md5 '33a447fb98ab3293ac40f869eedc17ff'

  depends_on 'pkg-config' => :build
  depends_on 'libdvdread'

  def install
    ENV.x11 # For libpng, etc.
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.j1 # Install isn't parallel-safe
    system "make install"
  end
end
