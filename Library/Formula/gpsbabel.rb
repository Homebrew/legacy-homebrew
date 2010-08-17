require 'formula'

class Gpsbabel <Formula
  url 'http://www.gpsbabel.org/plan9.php?token=2f4fd3fe&dl=gpsbabel-1.4.1.tar.gz',
        :using => :post
  homepage 'http://www.gpsbabel.org'
  md5 '512c4acfb12e20102fa5ceacef45a356'

  depends_on 'libusb'
  depends_on 'expat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
