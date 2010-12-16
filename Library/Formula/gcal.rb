require 'formula'

class Gcal <Formula
  url 'http://ftp.gnu.org/gnu/gcal/gcal-3.6.tar.gz'
  homepage 'http://www.gnu.org/software/gcal/'
  md5 '9c3819ca118d6e3adb6a716858cba7d6'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
