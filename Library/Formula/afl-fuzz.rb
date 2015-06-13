require "formula"

class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.82b.tgz"
  sha256 "ee9c0483820c85a3afe22e779456651403e364b95fe919a5b8e326a4272539ae"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "9a2a7c50b15a8c41682921a4e715921cd8e57b58c5284ab3f55370fbb8d2a3a0" => :yosemite
    sha256 "34f51daa0ad8ce36983ce0b70526bc608c80cd1b98c3f04848cfbfad868635ac" => :mavericks
    sha256 "832bd5b2ea5ed2096224cce4de78801b118e4a7439382e31855423a059faaf6d" => :mountain_lion
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
