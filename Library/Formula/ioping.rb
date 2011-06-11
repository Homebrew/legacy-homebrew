require 'formula'

class Ioping < Formula
  head 'http://ioping.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/ioping/'
  md5 '7b3ca5ba313e951e0b970a2ca1cf2512'

  def install
    system "make"
    system "make install PREFIX=#{prefix}"
  end
end
