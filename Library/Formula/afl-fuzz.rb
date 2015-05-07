require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.77b.tgz"
  sha256 "542f5ce26e1e6c7487bd0af9d0b776cded52014a9adcc1be9ca5bd4357a0c431"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "6432ca2854c3931990b9d38e60bfb8b43be030c3eafbe27467174f8454ff628c" => :yosemite
    sha256 "09f9ae233fada70859c751cd77944f55a097563a58cdaa26acd528fe5469a5ae" => :mavericks
    sha256 "e400018988d4e2fdc1e1327b9852d688e02eed6b7265c0de58ddd0ccb47955ea" => :mountain_lion
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
