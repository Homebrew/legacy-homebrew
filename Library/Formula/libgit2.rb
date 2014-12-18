require "formula"

class Libgit2 < Formula
  homepage "http://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.21.3.tar.gz"
  sha1 "d116cb15f76edf2283c85da40389e4fecc8d5aeb"

  head "https://github.com/libgit2/libgit2.git", :branch => "development"

  bottle do
    cellar :any
    sha1 "1eaa718a043b055902f0cd5c01a7a93b14836d85" => :yosemite
    sha1 "9b5d5f3026c699e05ad9a623ea37e004e800af30" => :mavericks
    sha1 "059ee25e0a3d46ad685b3d55394ae1c8a007da70" => :mountain_lion
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
