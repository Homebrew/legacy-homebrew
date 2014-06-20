require 'formula'

class Quassel < Formula
  homepage 'http://www.quassel-irc.org/'
  url 'http://quassel-irc.org/pub/quassel-0.10.0.tar.bz2'
  sha1 '305d56774b1af2a891775a5637174d9048d875a7'

  head 'https://github.com/quassel/quassel.git'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
