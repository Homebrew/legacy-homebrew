require 'formula'

class Libgit2 < Formula
  url 'https://github.com/libgit2/libgit2/zipball/v0.14.0'
  md5 '1f43e7895d2950eb9c19b716c0694f93'
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
