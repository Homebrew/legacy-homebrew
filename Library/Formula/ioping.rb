require 'formula'

class Ioping < Formula
  homepage 'http://code.google.com/p/ioping/'
  url 'https://ioping.googlecode.com/files/ioping-0.7.tar.gz'
  sha1 'f841244149830506daca1b052694965d94fe2408'

  head 'http://ioping.googlecode.com/svn/trunk/'

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  def test
    system "#{bin}/ioping", "-v"
  end
end
