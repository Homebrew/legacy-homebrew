require 'formula'

class YamlCpp < Formula
  homepage 'http://code.google.com/p/yaml-cpp/'
  url 'http://yaml-cpp.googlecode.com/files/yaml-cpp-0.3.0.tar.gz'
  sha1 '28766efa95f1b0f697c4b4a1580a9972be7c9c41'

  depends_on 'cmake' => :build

  option 'with-c++11', "Compile with C++11"

  def install
    if build.include? "with-c++11"
      ENV['CXXFLAGS'] = " -std=c++11 -stdlib=libc++"
    end
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
