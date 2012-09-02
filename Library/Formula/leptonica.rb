require 'formula'

class Leptonica < Formula
  homepage 'http://www.leptonica.org/'
  url 'http://www.leptonica.org/source/leptonica-1.69.tar.gz'
  sha1 '91199f99d2e78b15b76ffa6fc4e86ee458a330e8'

  option 'without-libpng', 'Build without PNG support'
  option 'without-jpeg', 'Build without JPEG support'
  option 'with-libtiff', 'Build with TIFF support'

  depends_on :libpng unless build.include? "without-libpng"
  depends_on 'jpeg' => :recommended unless build.include? "without-jpeg"
  depends_on 'libtiff' => :optional if build.include? "with-libtiff"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/yuvtest"
  end
end
