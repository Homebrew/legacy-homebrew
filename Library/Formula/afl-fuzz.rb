class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.96b.tgz"
  sha256 "03beb06f8993dcb37d348e53da19ca9d064c83fcedc9d87b0b506c73c310f27c"
  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "f26e0752ab00b1cd40b16bcb6731caa2162bc8f0f57e3c412ce9c9d814b98f32" => :el_capitan
    sha256 "fa6d5e3879d1b627b93f3f3ff32fae8c1473c71d1cc15640b33c1624553a8250" => :yosemite
    sha256 "e49e6508d15e54d370c427e7f8e353a6d3eb292d20600b5f2c912c4e8e149c04" => :mavericks
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
