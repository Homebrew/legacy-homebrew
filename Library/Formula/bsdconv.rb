require 'formula'

class Bsdconv < Formula
  url 'https://github.com/buganini/bsdconv/tarball/6.4'
  homepage 'https://github.com/buganini/bsdconv'
  head 'https://github.com/buganini/bsdconv.git'
  md5 '08865f419a679b47f5c0491dd8f899c9'

  def install
    system "make PREFIX=#{prefix}"
    system "make PREFIX=#{prefix} install"
  end

  def test
    system "bsdconv"
  end
end
