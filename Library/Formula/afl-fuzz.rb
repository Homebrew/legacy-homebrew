require "formula"

class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.83b.tgz"
  sha256 "5b1083537b549c74250acb43023d4bf0551508afcb07daa90330d40adb4e6efe"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "0c1f666cb9b1e564d1f08cd3f0186d410e16e1cf408d23c2ddd374f8cbcfef5f" => :yosemite
    sha256 "7b3b32a1623059d186e3fa78b72de772501107c53eab62c87d8f5484d9d0a831" => :mavericks
    sha256 "9d92d7eb9c958bf673fe5d8bd64bcc5ba4b502db9f8654773842b8cdac7b7d4b" => :mountain_lion
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
