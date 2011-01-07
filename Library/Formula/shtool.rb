require 'formula'

class Shtool <Formula
  url 'ftp://ftp.gnu.org/gnu/shtool/shtool-2.0.8.tar.gz'
  homepage 'http://www.gnu.org/software/shtool/'
  md5 'c5f7c6836882d48bc79049846a5f9c5b'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
