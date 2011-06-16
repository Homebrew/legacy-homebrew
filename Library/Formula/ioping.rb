require 'formula'

class Ioping < Formula
  url 'http://ioping.googlecode.com/files/ioping-0.5.tar.gz'
  head 'http://ioping.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/ioping/'
  md5 '9a62857bbf8885f66dfba061d62c3395'
  def install
    system "make"
    system "make install PREFIX=#{prefix}"
  end
end
