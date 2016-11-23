require 'formula'

class Libtool <Formula
  url 'http://ftp.gnu.org/gnu/libtool/libtool-2.2.8.tar.gz'
  homepage 'http://www.gnu.org/software/libtool/'
  md5 'cad2a7188242bc8dbab0645532ae3d6f'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
