require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.61b.tgz"
  sha256 "dfab81c17698c251887129b67d5eef3d50ab7103f222d554d8f0dde5b9ae6f6f"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "197c72c66a3f9aab5a41b7de2cda197145aa417bdaf86d459a6a003ef65acbdc" => :yosemite
    sha256 "ea9d9a3f0e3b5a4618af7e1c2976978ea694161b9e29d3e99adf4c27d13f8a3d" => :mavericks
    sha256 "4a6d71d4fe9c111a8fa7bb64e23f17405a61a485f2224f1d945712c2e2eb2f61" => :mountain_lion
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
