class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.06b.tgz"
  sha256 "e3d32f8aa0a5f0319b171881cde35d78af59396fe4c2c0b3430e2a20ff8745d4"

  bottle do
    sha256 "8c63ca3de1c390de853b022635226142e8f9d79b07dcc91078f39d19ad21e63f" => :el_capitan
    sha256 "69f4463e47aad2c91ae4c202c28063320848c214d6b67f755fe845d789825b09" => :yosemite
    sha256 "d6e6f9f661eb46736b1564ed9b5d4e202b5e9409ac386ff6d7252fd432182a84" => :mavericks
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
