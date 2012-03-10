require 'formula'

class Libgit2 < Formula
  homepage 'http://libgit2.github.com/'
  url 'https://github.com/libgit2/libgit2/tarball/v0.16.0'
  md5 'd75d4c2b0773abf2676f06dabdf5f31f'

  head 'https://github.com/libgit2/libgit2.git', :branch => 'master'

  depends_on 'cmake' => :build

  def install
    mkdir 'build' do
      system "cmake #{std_cmake_parameters} -DBUILD_TESTS=NO .."
      system "make install"
    end
  end
end
