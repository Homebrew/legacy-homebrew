require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.74b.tgz"
  sha256 "7e47db90f2a2f5d48e0b2355ece3ee28b7896b8b9a9991af5f8315a7df28305f"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "97d8c52c7c774f28b1b8905590be138e8697feedf79369dd60ba19dd66116a46" => :yosemite
    sha256 "e99daac39cf740d21c01bef36182550d2cf2fb57d2c5d22206de608524f2c029" => :mavericks
    sha256 "c681ae0aea2debb5b6a84688e6b79a8707ec601686a2ee3605d99e026702c05f" => :mountain_lion
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
