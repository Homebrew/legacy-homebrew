require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.78b.tgz"
  sha256 "24e21fd65de0840128b728e8a02077a3d65440948d25cddb3517c02f4aa38288"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "007def226fa5124dadbcce7bbbf956a2a16d6de2794ef5fc03bced035b6a8b7c" => :yosemite
    sha256 "a55b949f90b45338b37b766f6918e2b4a99a59e825d9aee94a7f7f82cae4fcfd" => :mavericks
    sha256 "adbec11bdc93d1f44427e9511677ab5597a01d551ceb9ac20199a27d917a03bd" => :mountain_lion
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
