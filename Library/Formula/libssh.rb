require 'formula'

class Libssh < Formula
  homepage 'http://www.libssh.org/'
  url 'http://git.libssh.org/projects/libssh.git/snapshot/libssh-0.6.0.tar.gz'
  sha1 'c6cf887020bf8499992c4533f11c2bdd3c08d10c'

  depends_on 'cmake' => :build

  def install
    cd 'build' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
