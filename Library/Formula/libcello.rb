require 'formula'

class Libcello < Formula
  homepage 'http://libcello.org/'
  url 'http://libcello.org/static/libCello-1.0.0.tar.gz'
  sha1 '005466d3dab88bf39e466bd12e9522a80aad617a'

  head 'https://github.com/orangeduck/libCello.git'

  def install
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
