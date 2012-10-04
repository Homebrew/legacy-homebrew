require 'formula'

class Minikonoha < Formula
  homepage 'http://konohascript.org'
  head 'https://github.com/konoha-project/minikonoha.git'
  url 'https://github.com/konoha-project/minikonoha/tarball/v0.1'
  version '0.1'
  sha1 '0ef5d07867e34a3d4674a4d57c95ca0da18f0da0'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_args + ['..']
    mkdir 'build'
    cd 'build' do
      system 'cmake', *args
      system 'make install'
    end
  end
end
