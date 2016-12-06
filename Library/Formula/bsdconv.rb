require 'formula'

class Bsdconv < Formula
  url 'https://github.com/buganini/bsdconv/tarball/7.3'
  homepage 'https://github.com/buganini/bsdconv'
  head 'https://github.com/buganini/bsdconv.git'
  md5 '29a4a350f4c6986df628f4210f2cbb37'

  def install
    system "make PREFIX=#{prefix}"
    system "make PREFIX=#{prefix} install"
  end

  def test
    system "bsdconv"
  end
end
