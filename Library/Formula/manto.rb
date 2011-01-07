require 'formula'

class Manto <Formula
  url 'http://manto.googlecode.com/files/manto-1.0.0.tar.gz'
  homepage 'http://code.google.com/p/manto/'
  md5 '59be0b24d13b9ac68ed15958ac7d169a'

  def install
    system "make"
    bin.install "manto"
    man1.install gzip("manto.1")
  end
end
