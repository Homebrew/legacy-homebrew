require 'formula'

class YamlCpp < Formula
  homepage 'http://code.google.com/p/yaml-cpp/'
  url 'http://yaml-cpp.googlecode.com/files/yaml-cpp-0.5.1.tar.gz'
  sha1 '9c5414b4090491e96d1b808fe8628b31e625fdaa'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
