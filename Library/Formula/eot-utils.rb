require 'formula'

class EotUtils < Formula
  homepage 'http://www.w3.org/Tools/eot-utils/'
  url 'http://www.w3.org/Tools/eot-utils/eot-utilities-1.1.tar.gz'
  sha1 '7e8a68ba1ae4b533113e7965aa2cca133367f31f'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
