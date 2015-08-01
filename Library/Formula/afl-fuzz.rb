class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.85b.tgz"
  sha256 "feb2bf6008d9f3a5c3e26295a9063168e98a2797e86b97b24ad8faa50fab8456"
  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "daf905b47531442caf0e5b9584e0b4d1d7bd2be1a4d6d9af9391d9e0b8deef2e" => :yosemite
    sha256 "cf5a8517524d36590daf4c2d5faa887721b16a83981479f74746ec664a53daeb" => :mavericks
    sha256 "ea2a25b1e69bd02d25b6164691bcc903a6bd088f44bf90f9839dd65797074a5f" => :mountain_lion
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
