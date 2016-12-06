require 'formula'

class Npk < Formula
  homepage 'http://github.com/lqez/npk/'
  url 'https://github.com/lqez/npk/archive/v1.9.tar.gz'
  sha1 'c54bbb3a39ac9214baa14b5a90f6e893e90c7e3e'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", "-DDEV_MODE=True", *std_cmake_args
    system "make install"
  end

  def test
    system "#{bin}/npk", "-version"
  end
end
