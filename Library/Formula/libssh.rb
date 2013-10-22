require 'formula'

class Libssh < Formula
  homepage 'http://www.libssh.org/'
  url 'https://red.libssh.org/attachments/download/51/libssh-0.5.5.tar.gz'
  sha1 'e701476ec43f85178bdb36fbb58aa45417a38f5e'

  depends_on 'cmake' => :build

  def install
    mkdir 'build' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
