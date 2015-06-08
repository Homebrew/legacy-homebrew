require "formula"

class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.80b.tgz"
  sha256 "e042cfe30d03ef6df3ae92619408e236d1a8e9bb6cf94ca107c4519e23161401"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "0c23c81900d04fe803b19ffdeee8ce368f2a9a9d1d79d830bcb1c480aeba8d75" => :yosemite
    sha256 "310c0ab40839d7d38563b513804c84ddec2cf00105d51cdec244bf26bdd13511" => :mavericks
    sha256 "038b09c7fac10774a39694dd5e783dab0a0c6fc24c293639a50f010be7557051" => :mountain_lion
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
