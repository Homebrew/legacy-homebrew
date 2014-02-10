require 'formula'

class Libssh < Formula
  homepage 'http://www.libssh.org/'
  url 'http://git.libssh.org/projects/libssh.git/snapshot/libssh-0.6.1.tar.gz'
  sha1 '2ad5f0afc9983291d3639812212f0f8babc1ba81'

  depends_on 'cmake' => :build

  def install
    cd 'build' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
