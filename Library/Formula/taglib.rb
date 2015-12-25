class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.github.io/"
  url "https://github.com/taglib/taglib/archive/v1.9.1.tar.gz"
  sha256 "d4da9aaaddf590ff15273b9b2c4622b6ce8377de0f40bab40155d471ede9c585"

  head "https://github.com/taglib/taglib.git"

  bottle do
    cellar :any
    revision 1
    sha256 "1fce4606850daa8617ea9ed41970f0ec60c7348a0f7ad0f7363523a5798585c6" => :el_capitan
    sha256 "d6b357a5a7e1fda27486acc6c25a6e294631d4b01ddbc320d865196f31d86c07" => :yosemite
    sha256 "7878267672c73747fdabfacb1043ab4eb54f757e826f4413be1020409bf4ede4" => :mavericks
    sha256 "6f3a987dc2f35a7446ac29ad7b8050466528b7ba620e0ca8aac7f4fbbdb07a52" => :mountain_lion
  end

  depends_on "cmake" => :build

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "cmake", "-DWITH_MP4=ON", "-DWITH_ASF=ON", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
