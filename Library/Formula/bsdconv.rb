require 'formula'

class Bsdconv < Formula
  url 'https://github.com/buganini/bsdconv/tarball/6.1'
  homepage 'https://github.com/buganini/bsdconv'
  head 'https://github.com/buganini/bsdconv.git'
  md5 '6b8ccb9ef8143f077882ebeb387e4e4a'

  def install
    system "make PREFIX=#{prefix} install"
  end

  def test
    system "bsdconv"
  end
end
