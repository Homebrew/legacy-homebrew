require 'formula'

class Tiff2png < Formula
  homepage 'http://www.libpng.org/pub/png/apps/tiff2png.html'
  url 'https://people.xiph.org/~giles/tiff2png/tiff2png-0.92.tar.gz'
  sha256 'bf743ae5b231d690202eb8a552f173619815533172417aeb3f8a75e13315f0ed'

  depends_on 'libtiff'
  depends_on 'libpng'
  depends_on 'jpeg'

  def install
    system "make"
    bin.install 'tiff2png'
  end

  test do
    system "#{bin}/tiff2png", test_fixtures("test.tiff")
  end
end
