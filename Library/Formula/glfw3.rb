require 'formula'

class Glfw3 < Formula
  homepage 'http://www.glfw.org/'
  url 'http://downloads.sourceforge.net/project/glfw/glfw/3.0.1/glfw-3.0.1.tar.bz2'
  sha1 'bee5bf36514554986b7c454d03a276095e057c02'

  depends_on 'cmake' => :build

  option :universal
  option :shared, 'Build shared library only (defaults to building static only)'

  def install
    ENV.universal_binary if build.universal?
    args = std_cmake_args + %W[
      -DGLFW_BUILD_EXAMPLES=0
      -DGLFW_BUILD_TESTS=0
      -DGLFW_USE_CHDIR=1
      -DGLFW_USE_MENUBAR=1
    ]
    args << '-DBUILD_SHARED_LIBS=1' if build.include? 'shared'
    args << '-DGLFW_BUILD_UNIVERSAL=1' if build.universal?
    args << '.'
    system 'cmake', *args
    system 'make', 'install'
    if build.include?('shared')
        rm (lib+'libglfw.dylib') # don't conflict with libglfw 2.x
    end
  end
end
