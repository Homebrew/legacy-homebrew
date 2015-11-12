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
    sha1 "431580f12a7811288b6e3b187ca75bf5e321fd7c" => :yosemite
    sha1 "7b9a9466fcbfb5952b7c97e739fa38a94e110f16" => :mavericks
    sha1 "9f12bf0949b250e67cb606cf389a99d7d2bc49ca" => :mountain_lion
  end

  depends_on "cmake" => :build

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    ENV.append "CXXFLAGS", "-DNDEBUG=1"
    system "cmake", "-DWITH_MP4=ON", "-DWITH_ASF=ON", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
