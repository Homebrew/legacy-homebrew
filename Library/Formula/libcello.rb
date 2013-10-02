require 'formula'

class Libcello < Formula
  homepage 'http://libcello.org/'
  head 'https://github.com/orangeduck/libCello.git'
  url 'http://libcello.org/static/libCello-1.1.2.tar.gz'
  sha1 '48140f4e42c097367e7dd4fee9b911b25b6c9e6c'

  def install
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
