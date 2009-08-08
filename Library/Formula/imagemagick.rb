require 'brewkit'

class Imagemagick <Formula
  @url='ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-6.5.4-9.tar.bz2'
  @md5='25391113fbcd5642b67949756fd078cb'
  @homepage='http://www.imagemagick.org'

  def deps
    LibraryDep.new 'jpeg'
  end

  def install
    ENV.libpng
    ENV.deparallelize

    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'

    system "./configure", "--disable-dependency-tracking",
                          "--without-maximum-compile-warnings",
                          "--prefix=#{prefix}",
                          "--disable-osx-universal-binary",
                          "--without-perl" # I couldn't make this compile
    system "make install"

    # We already copy these in
    d=prefix+'share'+'ImageMagick'
    (d+'NEWS.txt').unlink
    (d+'LICENSE').unlink
    (d+'ChangeLog').unlink
  end

  def caveats
    "This package is a bit of a mess, lots of components don't get compiled."
  end
end