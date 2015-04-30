require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.74b.tgz"
  sha256 "7e47db90f2a2f5d48e0b2355ece3ee28b7896b8b9a9991af5f8315a7df28305f"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "f5bd433a81d9c03ae41c673befa1f5195162bcdc17f26f2b1641dbaf4dc6bb56" => :yosemite
    sha256 "cc9191c9ab48527be2faf151a384558cedf5f6794d9958382244c138a9f28261" => :mavericks
    sha256 "caae81fc4165174857cfdb24bb4a124f3732cd78d4595fdf63ed90c8eb96ba81" => :mountain_lion
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
