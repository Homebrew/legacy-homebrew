require 'formula'

class Imlib2 <Formula
  url 'http://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.4/imlib2-1.4.4.tar.bz2'
  homepage 'http://sourceforge.net/projects/enlightenment/files/'
  md5 'b6de51879502e857d5b1f7622267a030'

  depends_on 'pkg-config' => :build

  def install
    ENV.x11 # For freetype
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-amd64=no"
    system "make install"
  end
end
