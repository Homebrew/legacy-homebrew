require 'formula'

class Imlib2 < Formula
  homepage 'http://sourceforge.net/projects/enlightenment/files/'
  url 'http://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.5/imlib2-1.4.5.tar.bz2'
  md5 '859e5fede51ec819f4314eee11da3ea5'

  depends_on 'pkg-config' => :build

  def install
    ENV.x11 # For freetype
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-amd64=no"
    system "make install"
  end
end
