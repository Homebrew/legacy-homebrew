require 'brewkit'

# some credit to http://github.com/maddox/magick-installer

class Imagemagick <Formula
  @url='ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-6.5.5-4.tar.bz2'
  @md5='8cb7471a50428e4892ee46aa404e54c2'
  @homepage='http://www.imagemagick.org'

  def deps
    { :required => 'jpeg', :optional => %w[libwmf libtiff little-cms ghostscript] }
  end

  def install
    ENV.libpng
    ENV.deparallelize

    # TODO eventually these will be external optional dependencies
    # but for now I am lazy

    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'

    system "./configure", "--disable-dependency-tracking",
                          "--without-maximum-compile-warnings",
                          "--prefix=#{prefix}",
                          "--disable-osx-universal-binary",
                          "--with-gs-font-dir=#{prefix}/share/ghostscript/fonts",
                          "--without-perl" # I couldn't make this compile
    system "make install"

    # We already copy these in
    d=prefix+'share'
    (d+'NEWS.txt').unlink
    (d+'LICENSE').unlink
    (d+'ChangeLog').unlink
  end

  def caveats
    "I'm not a heavy user of ImageMagick, so please check everything is installed."
  end
end