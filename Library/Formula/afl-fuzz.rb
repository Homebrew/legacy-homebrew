class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.06b.tgz"
  sha256 "e3d32f8aa0a5f0319b171881cde35d78af59396fe4c2c0b3430e2a20ff8745d4"

  bottle do
    revision 1
    sha256 "64de2cd7b7a878dd97997e770af1732e1c63f432077858332fb632008e85fc01" => :el_capitan
    sha256 "d0da382d949c7d990b54fc9939c11976b105879aaa96396c4aa7a10ed5811097" => :yosemite
    sha256 "2a78c2426e3d3299c1e3643dafe8113138fdea34166541f427af877f93bbce1f" => :mavericks
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
