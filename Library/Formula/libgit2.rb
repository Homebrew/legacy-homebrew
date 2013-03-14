require 'formula'

class Libgit2 < Formula
  homepage 'http://libgit2.github.com/'
  url 'https://github.com/libgit2/libgit2/tarball/v0.17.0'
  sha1 'a868978e1d322d967fb7877b757f7c6b81b37923'

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
