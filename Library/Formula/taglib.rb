class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.github.io/"
  url "https://taglib.github.io/releases/taglib-1.10.tar.gz"
  sha256 "24c32d50042cb0ddf162eb263f8ac75c5a158e12bf32ed534c1d5c71ee369baa"

  head "https://github.com/taglib/taglib.git"

  bottle do
    cellar :any
    sha256 "083ede2ae70eabf409a82e4999aa78f027ecb8c0b71065008eee90d4a4ccc59d" => :el_capitan
    sha256 "60a0e999802c0a3b4aced2375cbe0cb94744329bd9773beb18bbefb99b5692c4" => :yosemite
    sha256 "7f673f94a4263441327b83691f47c56605b8f4d20e7129c5d2883b8f603dcc15" => :mavericks
  end

  option :cxx11

  depends_on "cmake" => :build

  def install
    ENV.cxx11 if build.cxx11?
    system "cmake", "-DWITH_MP4=ON", "-DWITH_ASF=ON", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
