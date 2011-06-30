require 'formula'

class Binwalk < Formula
  url 'http://binwalk.googlecode.com/files/binwalk-0.3.5.tar.gz'
  homepage 'http://binwalk.googlecode.com/'
  md5 'efac7cec9d429e72615a84a3a9710e95'

  depends_on 'libmagic'

  def install
      ENV['LDFLAGS']='-L/usr/local/Cellar/libmagic/5.04/lib'
      ENV['CFLAGS']='-I/usr/local/Cellar/libmagic/5.04/include'
      ENV['CPPFLAGS']='-I/usr/local/Cellar/libmagic/5.04/include'
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
