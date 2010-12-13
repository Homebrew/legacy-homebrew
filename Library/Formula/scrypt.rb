require 'formula'

class Scrypt <Formula
  url 'http://www.tarsnap.com/scrypt/scrypt-1.1.6.tgz'
  homepage 'http://www.tarsnap.com/scrypt.html'
  md5 'a35523cd497f7283635ce881db39c2e2'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
