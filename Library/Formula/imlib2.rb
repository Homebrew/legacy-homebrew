require 'formula'

class Imlib2 < Formula
  homepage 'http://sourceforge.net/projects/enlightenment/files/'
  url 'http://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.5/imlib2-1.4.5.tar.bz2'
  sha1 'af86a2c38f4bc3806db57e64e74dc9814ad474a0'

  depends_on 'pkg-config' => :build
  depends_on :x11 # for Freetype

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-amd64=no"
    system "make install"
  end
end
