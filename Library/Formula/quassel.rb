require 'formula'

class Quassel < Formula
  homepage 'http://www.quassel-irc.org/'
  url 'http://www.quassel-irc.org/pub/quassel-0.9.1.tar.bz2'
  sha1 '82bc8ad2f5c0d61a8ec616b84df0504589f19371'

  head 'https://github.com/quassel/quassel.git'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
