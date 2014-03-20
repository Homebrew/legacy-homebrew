require 'formula'

class Libcello < Formula
  homepage 'http://libcello.org/'
  head 'https://github.com/orangeduck/libCello.git'
  url 'http://libcello.org/static/libCello-1.1.7.tar.gz'
  sha1 'e00e92ccdaf16c3443e0c75421b6cc73b1f727b1'

  def install
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
