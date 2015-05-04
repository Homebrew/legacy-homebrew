require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.75b.tgz"
  sha256 "ca9b691cb92631881d5491ce54afe2a7e447a140d0497555cefb739be72dc188"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "ad0ffdd261b79feea939dda941c081563f46290cb1f399873ee47911f01a4fff" => :yosemite
    sha256 "603a20b32b25d47bd3bf7c872ee76b44a88739c5ff6f5dfe32debe6094c5107c" => :mavericks
    sha256 "4b027255596c7c43fc1e4128883661672c0dbfcd99047c626de1a39115557e0f" => :mountain_lion
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    exe_file = testpath/"test"

    cpp_file.write <<-EOS.undent
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    system "#{bin}/afl-clang++", "-g", cpp_file, "-o", exe_file
    output = `#{exe_file}`
    assert_equal 0, $?.exitstatus
    assert_equal output, "Hello, world!"
  end
end
