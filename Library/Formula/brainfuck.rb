require "formula"

class Brainfuck < Formula
  homepage "https://github.com/FabianM/brainfuck"
  url "https://github.com/FabianM/brainfuck/archive/2.6.4.tar.gz"
  sha1 "678f671b389bf12a07ace7203478b62e978eeda8"
  head "https://github.com/FabianM/brainfuck.git"

  depends_on "cmake" => :build

  option "with-debug", "Install with the debug extension."

  def install
    args = std_cmake_args
    args << "-DENABLE_DEBUG" if build.with? "debug"
    args << "."

    system "cmake", *args
    system "make"
    bin.install "brainfuck"
    man1.install "man/brainfuck.1"
  end
end
