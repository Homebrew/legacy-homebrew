require 'formula'

class Libosip <Formula
  url 'http://ftp.gnu.org/gnu/osip/libosip2-3.3.0.tar.gz'
  homepage 'http://www.gnu.org/software/osip/'
  md5 '81493bb4d4ae6d55b71a0d4369339125'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
