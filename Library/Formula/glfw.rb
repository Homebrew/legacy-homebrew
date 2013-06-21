require 'formula'

class Glfw < Formula
  homepage 'http://www.glfw.org/'
  url 'http://sourceforge.net/projects/glfw/files/glfw/3.0.1/glfw-3.0.1.zip'
  sha1 '67962e3be4d1406c1ea0a538f576136b6607faf2'

  depends_on 'cmake' => :build

  option :universal
  option 'static', 'Build static libraries'
  option 'build-examples', 'Build examples'
  option 'build-tests', 'Build test programs'

  def install
    ENV.universal_binary if build.universal?

    args = std_cmake_args
    args << '-DBUILD_SHARED_LIBS=FALSE' if build.include? 'static'
    args << '-DGLFW_BUILD_EXAMPLES=TRUE' if build.include? 'build-examples'
    args << '-DGLFW_BUILD_TESTS=TRUE' if build.include? 'build-tests'
    args << '-DGLFW_BUILD_UNIVERSAL=TRUE' if build.universal?

    system 'cmake', '.', *args
    system 'make', 'install'
  end
end
