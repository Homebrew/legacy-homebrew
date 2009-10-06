require 'brewkit'

# some credit to http://github.com/maddox/magick-installer

class Imagemagick <Formula
  @url='ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-6.5.6-5.tar.gz'
  @md5='668919a5a7912fb6778975bc55893004'
  @homepage='http://www.imagemagick.org'

  depends_on 'jpeg'
  depends_on 'libwmf' => :optional
  depends_on 'libtiff' => :optional
  depends_on 'little-cms' => :optional
  depends_on 'ghostscript' => :recommended

  def skip_clean? path
    path.extname == '.la'
  end

  def install
    ENV.libpng
    ENV.deparallelize
    ENV.O3 # takes forever otherwise

    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'

    system "./configure", "--disable-static",
                          "--with-modules",
                          "--without-magick-plus-plus",
                          "--disable-dependency-tracking",
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
