require 'formula'

class Ioping < Formula
  url 'http://ioping.googlecode.com/files/ioping-0.6.tar.gz'
  head 'http://ioping.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/ioping/'
  sha1 '4b3860a6af0755467ebe67c09f36ddaebd9be3e7'

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
