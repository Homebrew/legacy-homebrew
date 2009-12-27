require 'formula'

class Remind <Formula
  url 'http://www.roaringpenguin.com/files/download/remind-03.01.07.tar.gz'
  homepage 'http://www.roaringpenguin.com/products/remind'
  md5 '9335189e78a11b78d848aeade30058d6'

  def install
      configure_args = [
          "--prefix=#{prefix}",
          "--disable-debug",
          "--disable-dependency-tracking",
      ]
    system "./configure", *configure_args
    system "make install"
  end
end
