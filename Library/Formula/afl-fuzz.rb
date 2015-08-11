class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.86b.tgz"
  sha256 "19588e43d14d3f76c5970f7e64ab314d13b325198a7a8eff8a9e3d6a1cb3c9af"
  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "376f6bf5d6c4a1a71f57526dbfc960fda542bd2d6e55bc19e90f51c0bd26e95f" => :yosemite
    sha256 "856e04bfc3c6f0819fe8d61fa35653d9ee3d264e9bd9259f6c471abc04200ca1" => :mavericks
    sha256 "a305bb7086bc30f1c6599764ad97e6b120f334c393f554ff27fa46d1d004895c" => :mountain_lion
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
