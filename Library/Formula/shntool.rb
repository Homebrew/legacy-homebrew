require 'formula'

class Shntool < Formula
  homepage 'http://etree.org/shnutils/shntool/'
  url 'http://etree.org/shnutils/shntool/dist/src/shntool-3.0.10.tar.gz'
  sha1 '7a2bc8801e180cf582f0e39775603582e35d50d2'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
