require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-0.85b.tgz"
  sha1 "036c6064b24c3211524d7713d9b0f0590d7255f7"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

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
