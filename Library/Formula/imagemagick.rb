require 'brewkit'

# some credit to http://github.com/maddox/magick-installer

class Imagemagick <Formula
  @url='ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-6.5.5-10.tar.bz2'
  @md5='36bcef67cae5d5fce2899acb9200213a'
  @homepage='http://www.imagemagick.org'

  depends_on 'jpeg'
  depends_on 'libwmf' => :optional
  depends_on 'libtiff' => :optional
  depends_on 'little-cms' => :optional
  depends_on 'ghostscript' => :recommended

  def install
    ENV.libpng
    ENV.deparallelize

    # TODO eventually these will be external optional dependencies
    # but for now I am lazy

    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'

    system "./configure", "--disable-static",
                          "--with-modules",
                          "--without-magick-plus-plus",
                          "--disable-dependency-tracking",
                          "--disable-shared",
                          "--without-maximum-compile-warnings",
                          "--prefix=#{prefix}",
                          "--disable-osx-universal-binary",
                          "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts",
                          "--without-perl" # I couldn't make this compile
    system "make install"

    # We already copy these into the keg root
    (share+'ImageMagick'+'NEWS.txt').unlink
    (share+'ImageMagick'+'LICENSE').unlink
    (share+'ImageMagick'+'ChangeLog').unlink
  end

  def caveats
    "If there is something missing that you need with this formula, please create an issue at #{HOMEBREW_WWW}"
  end
end