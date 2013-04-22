require 'formula'

class Libgit2 < Formula
  homepage 'http://libgit2.github.io/'
  url 'https://github.com/libgit2/libgit2/archive/v0.18.0.tar.gz'
  sha1 '08b6b7520580615c5549ff739ba7d0c8e3617188'

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
