class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.07b.tgz"
  sha256 "9dd324bc3930ec1dbb44d00df8dcf8a3c8ca54b765665cc7f20b89e71d70b184"

  bottle do
    sha256 "e5508f61b3e6c1671c702e753f20627de6690037348a00580f34407923e5c7f0" => :el_capitan
    sha256 "c91f51ae59bbef6446885d51b4a8512af5ce1ee351ebf847317639d045b811f1" => :yosemite
    sha256 "ab84d803f518d4e7fc23236e32dd4452e0f39e910d2155133cd3517a87336c66" => :mavericks
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
