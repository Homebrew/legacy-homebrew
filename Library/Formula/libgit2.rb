require 'formula'

class Libgit2 < Formula
  url 'https://github.com/libgit2/libgit2/zipball/v0.13.0'
  md5 'd9e5bb792bc6d7aeb0c4ea90aac074e1'
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
