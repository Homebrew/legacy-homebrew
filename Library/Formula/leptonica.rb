require 'formula'

class Leptonica < Formula
  homepage 'http://www.leptonica.org/'
  url 'http://www.leptonica.org/source/leptonica-1.69.tar.gz'
  sha1 '91199f99d2e78b15b76ffa6fc4e86ee458a330e8'
  revision 1

  depends_on 'libpng'
  depends_on 'jpeg'
  depends_on 'libtiff'

  conflicts_with 'osxutils',
    :because => "both leptonica and osxutils ship a `fileinfo` executable."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/yuvtest"
  end
end
