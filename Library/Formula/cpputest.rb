require 'formula'

class Cpputest < Formula
  homepage 'http://www.cpputest.org/'
  url 'https://github.com/cpputest/cpputest.github.io/blob/master/releases/cpputest-3.5.tar.gz?raw=true'
  sha1 '072e205a535d145371914ad5ca0711432d23d5a2'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
