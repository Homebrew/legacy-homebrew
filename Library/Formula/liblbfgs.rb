require 'formula'

class Liblbfgs < Formula
  homepage 'http://www.chokkan.org/software/liblbfgs'
  url 'https://github.com/downloads/chokkan/liblbfgs/liblbfgs-1.10.tar.gz'
  sha1 'fde08e7b842cd125364cb9db9d66fd61dcf37d21'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
