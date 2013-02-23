require 'formula'

class Ioping < Formula
  homepage 'http://code.google.com/p/ioping/'
  url 'http://ioping.googlecode.com/files/ioping-0.6.tar.gz'
  sha1 '4b3860a6af0755467ebe67c09f36ddaebd9be3e7'

  head 'http://ioping.googlecode.com/svn/trunk/'

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
