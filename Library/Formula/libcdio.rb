require 'formula'

class Libcdio <Formula
  url 'http://ftp.gnu.org/gnu/libcdio/libcdio-0.82.tar.gz'
  md5 '1c29b18e01ab2b966162bc727bf3c360'
  homepage 'http://www.gnu.org/software/libcdio/'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
