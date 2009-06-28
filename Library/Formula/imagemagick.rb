require 'brewkit'

class Imagemagick <Formula
  @url='ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-6.5.3-10.tar.bz2'
  @md5='ad485ed0eca5eb8b8a1649bae40cec7d'
  @homepage='http://www.imagemagick.org'

  def deps
    LibraryDep.new 'jpeg'
  end

  def install
    system "./configure --disable-debug --disable-dependency-tracking --without-maximum-compile-warnings --prefix='#{prefix}'"
    ENV['MAKEFLAGS']=''
    system "make install"
  end
end