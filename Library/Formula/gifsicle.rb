require 'formula'

class Gifsicle <Formula
  url 'http://www.lcdf.org/gifsicle/gifsicle-1.60.tar.gz'
  homepage 'http://www.lcdf.org/gifsicle/'
  md5 '2629d5894e189e251f148eec8e7805d6'

  def install
    system "./configure", "--enable-all", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
