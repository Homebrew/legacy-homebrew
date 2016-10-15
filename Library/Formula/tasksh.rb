class Tasksh < Formula
  homepage "http://tasktools.org/"
  url "http://taskwarrior.org/download/tasksh-1.0.0.tar.gz"
  version "1.0.0"
  sha256 "9accc81f5ae3a985e33be728d56aba0401889d21f856cd94734d73c221bf8652"
  depends_on "task"
  depends_on "cmake" => :build

test do
    system "make", "test"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
