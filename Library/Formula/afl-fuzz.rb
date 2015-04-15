require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.65b.tgz"
  sha256 "5dee78bdb069eeb704456ac017455d34d8a1596068266adebdb29b3d5b0ea817"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "f364972749e6b5966f90d5609d913c6384fb88b4857b429e191b8be8453fb626" => :yosemite
    sha256 "d87d5f1482464807ab0cca6f2da6238e8a0f6af60fd6bf8afec65b757ee9b027" => :mavericks
    sha256 "6a791a2bc52e37d28cea51ccdc9f6c0a6c78ba9b013a0edc54ed865b23acfb38" => :mountain_lion
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
