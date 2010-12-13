require 'formula'

class Cksfv <Formula
  url 'http://zakalwe.fi/~shd/foss/cksfv/files/cksfv-1.3.14.tar.bz2'
  homepage 'http://zakalwe.fi/~shd/foss/cksfv/'
  md5 '138bff42ab23fbba8cca0ae14b2d9e52'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
