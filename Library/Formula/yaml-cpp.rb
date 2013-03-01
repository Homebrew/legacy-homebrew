require 'formula'

class YamlCpp < Formula
  homepage 'http://code.google.com/p/yaml-cpp/'
  url 'http://yaml-cpp.googlecode.com/files/yaml-cpp-0.5.0.tar.gz'
  sha1 '575ece77122bffc392e6e9bc7389a1efcdb6bc97'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
