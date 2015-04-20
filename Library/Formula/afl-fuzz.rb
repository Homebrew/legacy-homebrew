require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.69b.tgz"
  sha256 "f471d6299c01a974a8a0598f61b67f0baad95f70c5a8eb89c738acd31fdef00e"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "0224e180db92690da1eb0d39b5827ce3776ee4fcdb81f8652cc303f65d5613a6" => :yosemite
    sha256 "c35bbaa98f9d267dac150cdb61c55a747e3d37de747db1c432e62aa0ac448ff3" => :mavericks
    sha256 "b79e91fc5f3de347cccf5fa32e228695c1b01a266f4e634c7dfb7c5da329766e" => :mountain_lion
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
