require 'formula'

class Glfw3 < Formula
  homepage 'http://www.glfw.org/'
  url 'http://sourceforge.net/projects/glfw/files/glfw/3.0.1/glfw-3.0.1.zip'
  sha1 '67962e3be4d1406c1ea0a538f576136b6607faf2'

  option :universal

  depends_on 'cmake' => :build

  conflicts_with 'glfw',
    :because => "glfw and glfw3 install the same library libglfw.dylib."

  def install
    ENV.universal_binary if build.universal?
    args = std_cmake_args
    args << '-DBUILD_SHARED_LIBS=1'
    mkdir 'glfw3-build' do
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
