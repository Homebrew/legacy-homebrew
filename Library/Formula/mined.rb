require 'formula'

class Mined < Formula
  homepage 'http://towo.net/mined/'
  url 'http://towo.net/mined/download/mined-2012.22.tar.gz'
  version '2012.22'
  sha1 '0f63bd8f659e7fc8a238ebeb21b3e7d56663d5b9'

  def install
    system "make"
    system "make install prefix=#{prefix}"
  end
end
