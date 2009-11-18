require 'formula'

class Cmatrix <Formula
  url 'http://www.asty.org/cmatrix/dist/cmatrix-1.2a.tar.gz'
  homepage ''
  md5 ''

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
