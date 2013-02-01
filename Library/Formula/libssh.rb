require 'formula'

class Libssh < Formula
  homepage 'http://www.libssh.org/'
  url 'http://www.libssh.org/files/0.5/libssh-0.5.3.tar.gz'
  sha1 '63f5f9e7d8b8e936048a51998a6f9be0e86866a7'

  depends_on 'cmake' => :build

  def install
    mkdir 'build' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
