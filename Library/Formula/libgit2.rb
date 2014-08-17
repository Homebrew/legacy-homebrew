require 'formula'

class Libgit2 < Formula
  homepage 'http://libgit2.github.com/'
  url 'https://github.com/libgit2/libgit2/archive/v0.21.0.tar.gz'
  sha1 '1534ecba1116ce8866e980499b2a3b5e67909bee'

  head 'https://github.com/libgit2/libgit2.git', :branch => 'development'

  bottle do
    cellar :any
    sha1 "5d71aa92ca16c0e792d134c1b93d4c55fd1fb2c5" => :mavericks
    sha1 "d62717c452965b9d90e1fb6142d62ff6f47b6403" => :mountain_lion
    sha1 "36f85d4daa70f51a77e99232167e210b98662169" => :lion
  end

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
