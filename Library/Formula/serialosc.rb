require 'formula'

class Serialosc < Formula
  head 'https://github.com/monome/serialosc.git'
  homepage 'http://www.monome.org'
  version '1.0'
  depends_on 'liblo'
  depends_on 'confuse'
  depends_on 'libmonome'


  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
