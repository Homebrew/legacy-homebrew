class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.95b.tgz"
  sha256 "21ec6bb8c182fd821d25c8b67283f81a632c4f74419c9db5fec0135dd0c9ae2a"
  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "5a3f8c04dbade911468c99df3026869e66c8571d8ed2b332c9864938391e58dd" => :el_capitan
    sha256 "ee3a8fcdebea7cf5139079df7944066c163a01b836fa7c780b289471355c8446" => :yosemite
    sha256 "ab8b6a0aadd6dc6d126d11f3990b58b2eeeaa8148c75cbc3ae430af4c554f088" => :mavericks
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
