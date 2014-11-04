require "formula"

class Libgit2 < Formula
  homepage "http://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.21.2.tar.gz"
  sha1 "a16a59df1bfe073483be0c58a81cdbc89f7b7070"

  head "https://github.com/libgit2/libgit2.git", :branch => "development"

  bottle do
    cellar :any
    sha1 "388688ca18d3ebe91dde4cb7b9fa67e632a4f9a0" => :yosemite
    sha1 "5bfd8d83f8ff1c62bea445c209efdb4ce3d3f641" => :mavericks
    sha1 "5b23f7fd5062d7bf1be3a3509d70502c594b1fc5" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "libssh2" => :optional
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..",
                      "-DBUILD_TESTS=NO",
                      *std_cmake_args
      system "make install"
    end
  end
end
