require 'formula'

class Libgit2 < Formula
  homepage 'http://libgit2.github.com/'
  url 'https://github.com/libgit2/libgit2/archive/v0.17.0.tar.gz'
  sha1 '0887ce3aa2b22c3a256bf5cd80e13f3766b27480'

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
