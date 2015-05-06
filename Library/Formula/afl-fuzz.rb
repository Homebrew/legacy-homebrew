require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.77b.tgz"
  sha256 "542f5ce26e1e6c7487bd0af9d0b776cded52014a9adcc1be9ca5bd4357a0c431"

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
