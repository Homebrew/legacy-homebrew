require 'formula'

class Libgit2 < Formula
  homepage 'http://libgit2.github.io/'
  url 'https://github.com/libgit2/libgit2/archive/v0.19.0.tar.gz'
  sha1 '72cc461d366c5ace3385470a1f209ff84d0a4bb3'

  head 'https://github.com/libgit2/libgit2.git', :branch => 'development'

  depends_on 'cmake' => :build

  def install
    mkdir 'build' do
      system "cmake", "..",
                      "-DBUILD_TESTS=NO",
                      *std_cmake_args
      system "make install"
    end
  end
end
