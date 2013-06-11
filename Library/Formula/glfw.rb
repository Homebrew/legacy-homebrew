require 'formula'

class Glfw < Formula
  homepage 'http://www.glfw.org/'
  url 'http://sourceforge.net/projects/glfw/files/glfw/2.7.8/glfw-2.7.8.zip'
  sha1 'b4f51221ffed0a064bb413074544a530ae2751ec'

  devel do
    url 'https://github.com/glfw/glfw.git', :branch => 'master'
    version '3.0-develop'
  end

  option :universal

  if build.devel?
    depends_on 'cmake' => :build
  end

  def install
    ENV.universal_binary if build.universal?

    if not build.devel?
      system 'make', "PREFIX=#{prefix}", 'cocoa-dist-install'
    else
      system 'cmake', '.', *std_cmake_args
      system 'make install'
    end
  end
end
