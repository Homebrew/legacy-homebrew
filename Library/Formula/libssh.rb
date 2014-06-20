require 'formula'

class Libssh < Formula
  homepage 'http://www.libssh.org/'
  url 'https://red.libssh.org/attachments/download/87/libssh-0.6.3.tar.xz'
  sha1 '8189255e0f684d36b7ca62739fa0cd5f1030a467'

  depends_on 'cmake' => :build

  def install
    mkdir 'build' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
