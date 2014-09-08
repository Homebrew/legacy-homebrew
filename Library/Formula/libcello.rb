require 'formula'

class Libcello < Formula
  homepage 'http://libcello.org/'
  head 'https://github.com/orangeduck/libCello.git'
  url 'http://libcello.org/static/libCello-1.1.7.tar.gz'
  sha1 'e00e92ccdaf16c3443e0c75421b6cc73b1f727b1'

  bottle do
    cellar :any
    sha1 "8d856cc8f5c920f4e230953d4001f7be293c3edc" => :mavericks
    sha1 "642659eb3b985edc99b8a83e28fa61fb7502424a" => :mountain_lion
    sha1 "70c8a20fd03ea6208948e8dc75df56eca383dfc5" => :lion
  end

  def install
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
