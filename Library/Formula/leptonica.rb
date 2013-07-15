require 'formula'

class Leptonica < Formula
  homepage 'http://www.leptonica.org/'
  url 'http://www.leptonica.org/source/leptonica-1.69.tar.gz'
  sha1 '91199f99d2e78b15b76ffa6fc4e86ee458a330e8'

  depends_on :libpng => :recommended
  depends_on 'jpeg' => :recommended
  depends_on 'libtiff' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/yuvtest"
  end
end
