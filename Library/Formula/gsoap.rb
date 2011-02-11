require 'formula'

class Gsoap <Formula
  url 'http://sourceforge.net/projects/gsoap2/files/gSOAP/gsoap_2.8.1.zip'
  homepage 'http://www.cs.fsu.edu/~engelen/soap.html'
  md5 'c9290f11628533d99d933d96a445437a'

  def install
    system "./configure --prefix=#{prefix}"
    system "make --jobs=1 install"
  end
end
