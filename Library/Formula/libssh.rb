require 'formula'

class Libssh < Formula
  homepage 'http://www.libssh.org/'
  url 'http://www.libssh.org/files/0.5/libssh-0.5.2.tar.gz'
  sha1 '4bf36d4052bd0c948e05bbf3b0cd0da8684ac00e'

  depends_on 'cmake' => :build

  def install
    mkdir 'build' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
