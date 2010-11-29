require 'formula'

class Archimedes <Formula
  url 'http://ftp.gnu.org/gnu/archimedes/archimedes-0.9.1.tar.gz'
  homepage 'http://www.gnu.org/software/archimedes/'
  md5 '57138f5c7b90adfac4ad469a7ad44be3'


  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
  end
end
