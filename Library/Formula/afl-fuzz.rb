require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-0.85b.tgz"
  sha1 "036c6064b24c3211524d7713d9b0f0590d7255f7"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha1 "5fb4f975d5fe80aea1c70a002967b845e907e6db" => :yosemite
    sha1 "c0b9253f84d3167c8bff7cf7148481910c0c16c2" => :mavericks
    sha1 "dcd756413b3a06bfcd4039184417bbc5f37df1f3" => :mountain_lion
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    exe_file = testpath/"a.out"

    cpp_file.write(
    <<-EOS.undent
      #include <iostream>

      int main() {
          std::cout << "Hello, world!";
      }
    EOS
    )

    system "afl-clang++", cpp_file, "-o", exe_file
    assert_equal `#{exe_file}`, "Hello, world!"
  end
end
