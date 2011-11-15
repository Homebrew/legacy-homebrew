require 'formula'

class Ioping < Formula
  url 'http://ioping.googlecode.com/files/ioping-0.6.tar.gz'
  head 'http://ioping.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/ioping/'
  md5 'f96b382a6517c7eac744291b04b928b1'

  def install
    system "make"
    system "make install PREFIX=#{prefix}"
  end
end
