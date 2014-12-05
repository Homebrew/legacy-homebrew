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
    # Try a sample compilation.
    sample_file = <<-eos
      #include <iostream>

      int main() {
          std::cout << "Hello, world!" << std::endl;
      }
    eos
    (testpath/"main.cpp").write(sample_file)

    system "afl-clang++", (testpath/"main.cpp")
  end
end
