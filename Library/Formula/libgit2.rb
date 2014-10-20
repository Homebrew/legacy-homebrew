require "formula"

class Libgit2 < Formula
  homepage "http://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.21.1.tar.gz"
  sha1 "8975eb3fa6999e30b1fa01a84b7b09d0a2672ac5"

  head "https://github.com/libgit2/libgit2.git", :branch => "development"

  bottle do
    cellar :any
    sha1 "e0588a7e02a24b141025ad5e6e507cb09831229d" => :mavericks
    sha1 "e8efca2c42c1053c8b468ff73e81eec1380bec14" => :mountain_lion
    sha1 "ede1558e9594d987ffa5ce33caec8edfdb1f6933" => :lion
  end

  depends_on "cmake" => :build
  depends_on "libssh2" => :optional

  def install
    mkdir "build" do
      system "cmake", "..",
                      "-DBUILD_TESTS=NO",
                      *std_cmake_args
      system "make install"
    end
  end
end
