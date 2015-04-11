require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.63b.tgz"
  sha256 "2f01b681404ec6f24300d74efc077c0f40f197443143ce143ec848511ef077ec"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "3441142dd73f9a572ca3ab9000b24d0665daf8f8ac2e123f8608b9db88bd7ce0" => :yosemite
    sha256 "01cce212d88be76eba02792536e77b367dddaa6cf04bb14c67d0769b1aad2142" => :mavericks
    sha256 "8cfb035bbd4228d7f28fbaf83ffc8e0024a4d52cf84d4519c5938c61b70c0073" => :mountain_lion
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
