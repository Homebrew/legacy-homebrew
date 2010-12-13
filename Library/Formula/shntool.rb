require 'formula'

class Shntool <Formula
  url 'http://etree.org/shnutils/shntool/dist/src/shntool-3.0.10.tar.gz'
  homepage 'http://etree.org/shnutils/shntool/'
  md5 '5d41f8f42c3c15e3145a7a43539c3eae'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
