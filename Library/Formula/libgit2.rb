require 'formula'

class Libgit2 < Formula
  url 'https://github.com/libgit2/libgit2/zipball/v0.15.0'
  md5 'b215209d19db5bd6d3510d3d203b7fd4'
  homepage 'http://libgit2.github.com/'

  head 'https://github.com/libgit2/libgit2.git', :branch => 'master'

  depends_on 'cmake' => :build

  def install
    mkdir 'build'
    Dir.chdir 'build' do
      system "cmake .. #{std_cmake_parameters} -DBUILD_TESTS=NO"
      system "make install"
    end
  end
end
