class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.10b.tgz"
  sha256 "8141291646024dcdd2e67c51fb68b4205d34c52e4b5693c88f6ce4a6bf1ebfe3"

  bottle do
    sha256 "1bd94905e2c30a4d36b10cfae6ad3e2150129317a9c8cde4d5c037d2fec05aeb" => :el_capitan
    sha256 "195e661f2078f95473ec51b4596fe8cfa563b8b35d0f0c5f735a531987eb1937" => :yosemite
    sha256 "45d942b7a2d0fa8564fa1e80c10531f58fdbe2ae9ab2e85e559aa3a0926c175e" => :mavericks
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
