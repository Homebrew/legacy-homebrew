require 'formula'

class Lightning <Formula
  url 'http://ftp.gnu.org/gnu/lightning/lightning-1.2.tar.gz'
  homepage 'http://www.gnu.org/software/lightning/'
  md5 'dcd2c46ee4dd5d99edd9930022ad2153'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
