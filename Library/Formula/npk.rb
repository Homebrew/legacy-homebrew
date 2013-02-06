require 'formula'

class Npk < Formula
  homepage 'http://github.com/lqez/npk/'
  url 'http://npk.googlecode.com/files/npk-1.9.tar.gz'
  sha1 'c54bbb3a39ac9214baa14b5a90f6e893e90c7e3e'

  head 'git://github.com/lqez/npk.git'

  depends_on 'cmake' => :build

  def install
    mkdir 'npk-build' do
      system "cmake", "..", "-DDEV_MODE=True", *std_cmake_args
      system "make install"
    end
  end

  def test
    mkdir 'npk-build' do
      system "make test"
    end
  end
end
