class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.86b.tgz"
  sha256 "19588e43d14d3f76c5970f7e64ab314d13b325198a7a8eff8a9e3d6a1cb3c9af"
  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "8c645688ee3728ad3c097fdc3f95953e47d8f1e902c05b545365d409a5f42a57" => :yosemite
    sha256 "40409f24fc3b6824916224ab6f4de9e24f3260829e2bee89bd18d76e50b9e5d4" => :mavericks
    sha256 "4f0be865e14f97b5df919dcf8deba117642af96e1fd5eb1d06ee4aa1e915d685" => :mountain_lion
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
