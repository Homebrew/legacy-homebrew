require 'formula'

class Graphicsmagick <Formula
  url 'http://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.7/GraphicsMagick-1.3.7.tar.bz2'
  homepage 'http://www.graphicsmagick.org/'
  md5 '42bfd382ddcda399880721170bcbf61b'

  depends_on 'jpeg'
  depends_on 'ghostscript' => :recommended
  depends_on 'libwmf' => :optional
  depends_on 'libtiff' => :optional
  depends_on 'little-cms' => :optional
  depends_on 'jasper' => :optional

  def install
    ENV.libpng
    ENV.gcc_4_2

    # we do not need to version the stuff in the main tree
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'

    system "./configure", "--prefix=#{prefix}", 
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--disable-static",
                          "--with-modules",
                          "--without-magick-plus-plus"

    system "make install"
  end
end
