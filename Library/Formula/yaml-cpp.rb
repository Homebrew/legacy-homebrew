require 'formula'

class YamlCpp < Formula
  homepage 'http://code.google.com/p/yaml-cpp/'
  url 'http://yaml-cpp.googlecode.com/files/yaml-cpp-0.5.1.tar.gz'
  sha1 '9c5414b4090491e96d1b808fe8628b31e625fdaa'

  depends_on 'cmake' => :build
  depends_on 'boost'

  option 'with-c++11', "Compile with C++11"

  def install
    if build.include? "with-c++11"
      ENV['CXXFLAGS'] = " -std=c++11 -stdlib=libc++"
    end
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
