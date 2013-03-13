require 'formula'

class Dvdauthor < Formula
  homepage 'http://dvdauthor.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/dvdauthor/dvdauthor/0.7.1/dvdauthor-0.7.1.tar.gz'
  sha1 'a9636d165bf546e3e2b25b7397c33dbfa2895e6a'

  # Dvdauthor will optionally detect ImageMagick or GraphicsMagick, too.
  # But we don't add either as deps because they are big.

  depends_on 'pkg-config' => :build
  depends_on 'libdvdread'
  depends_on :freetype
  depends_on :libpng

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.j1 # Install isn't parallel-safe
    system "make install"
  end
end
