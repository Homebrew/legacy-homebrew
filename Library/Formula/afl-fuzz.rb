require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.79b.tgz"
  sha256 "561a86e7133c8333ed9043ed84ac5daf6704e837ce5f392e3d7e94833488ad0c"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "048c5cd37c0419b5c25a6b2c934a7904987e4820005cbc3ff7b243509d56ae6c" => :yosemite
    sha256 "dacdd7182e85dad19cae548926b43ea5e7956c55aa8176d08faec915a3a7910a" => :mavericks
    sha256 "91f5c90f0b73b28aecea2ab462b92197ab041c517ec27ebed7e36dc5b838a898" => :mountain_lion
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
