require 'formula'

class Libssh < Formula
  url 'http://www.libssh.org/files/0.5/libssh-0.5.2.tar.gz'
  homepage 'http://www.libssh.org/'
  md5 '38b67c48af7a9204660a3e08f97ceba6'

  depends_on 'cmake' => :build

  def install
    mkdir 'build'
    cd 'build' do
      system "cmake .. #{std_cmake_parameters}"
      system "make install"
    end
  end
end
