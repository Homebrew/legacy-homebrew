require 'formula'

class Gpsbabel <Formula
  url 'http://www.gpsbabel.org/plan9.php?token=e3947850&dl=gpsbabel-1.4.0.tar.gz'
  homepage 'http://www.gpsbabel.org'
  md5 'c3f76c9e7582c2ec3a24e34e5346d8f9'

  depends_on 'libusb'
  depends_on 'expat'

  def download_strategy
    CurlPostDownloadStrategy
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
