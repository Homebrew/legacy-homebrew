require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Sfml < Formula
  homepage 'http://www.sfml-dev.org/'
  head 'https://github.com/LaurentGomila/SFML.git'

  depends_on 'cmake' => :build
  depends_on 'libsndfile' => :build

  def install
    system "cmake . -DCMAKE_INSTALL_FRAMEWORK_PREFIX=#{prefix} #{std_cmake_parameters}"
    system "make install" # if this fails, try separate make/make install steps
  end
end
