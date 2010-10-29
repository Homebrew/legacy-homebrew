require 'formula'

class Aimage <Formula
  url 'http://afflib.org/downloads/aimage-3.2.4.tar.gz'
  homepage 'http://afflib.org/software/aimage-the-advanced-disk-imager'
  md5 'bb6e4e91524612570a481b6470fe7cd1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
