require 'formula'

class YamlCpp < Formula
  homepage 'http://code.google.com/p/yaml-cpp/'
  url 'https://yaml-cpp.googlecode.com/files/yaml-cpp-0.5.1.tar.gz'
  sha1 '9c5414b4090491e96d1b808fe8628b31e625fdaa'

  option :cxx11
  option :universal
  option "with-static-lib", "Build a static library"

  depends_on 'cmake' => :build

  if build.cxx11?
    depends_on 'boost' => 'c++11'
  else
    depends_on 'boost'
  end

  def install
    ENV.cxx11 if build.cxx11?
    ENV.universal_binary if build.universal?
    args = std_cmake_args
    if build.with? "static-lib"
      args << "-DBUILD_SHARED_LIBS=OFF"
    else
      args << "-DBUILD_SHARED_LIBS=ON"
    end

    system "cmake", ".", *args
    system "make install"
  end
end
