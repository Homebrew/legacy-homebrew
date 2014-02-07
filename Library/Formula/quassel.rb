require 'formula'

class Quassel < Formula
  homepage 'http://www.quassel-irc.org/'
  url 'http://www.quassel-irc.org/pub/quassel-0.9.2.tar.bz2'
  sha1 'b32c76a4fc608c2e3a86a02456b4f4e996a815b3'

  head 'https://github.com/quassel/quassel.git'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
