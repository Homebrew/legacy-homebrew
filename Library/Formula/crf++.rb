require 'formula'

class Crfxx < Formula
  url 'http://downloads.sourceforge.net/project/crfpp/crfpp/0.54/CRF++-0.54.tar.gz'
  homepage 'http://sourceforge.net/projects/crfpp/'
  version '0.54'
  md5 'a3c12c99b25e06d18147d50f0f92e8d3'

  def install
    arg = ["--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"]

    system "./configure", *arg
    system "make"
    system "make install"
  end

  def test
    system "false"
  end
end