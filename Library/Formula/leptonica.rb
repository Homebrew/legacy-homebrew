require 'formula'

class Leptonica < Formula
  homepage 'http://www.leptonica.org/'
  url 'http://www.leptonica.com/source/leptonica-1.70.tar.gz'
  sha1 '2c7a893c48aec7844d6b2c7123a0ede7a0d8300e'

  depends_on :libpng => :recommended
  depends_on 'jpeg' => :recommended
  depends_on 'libtiff' => :optional

  conflicts_with 'osxutils',
    :because => "both leptonica and osxutils ship a `fileinfo` executable."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/yuvtest"
  end
end
