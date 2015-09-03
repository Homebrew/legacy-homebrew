class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.88b.tgz"
  sha256 "3bd4e2fef8e4528795ecefae21fad59ab04ee7c862c16e19753593fc27594082"
  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "701220022f07fd94562b73641f12ad7885753dd821f1e51485af26c0a357906e" => :yosemite
    sha256 "83d9c66cf2d45f51ec62fd7e9e8329d653c7bf278f000ec7cf1b338500834f06" => :mavericks
    sha256 "6f020c9a629c9b1ec77f3382f52f20547be3fb0329f1287c28ac1bdc66c57974" => :mountain_lion
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
