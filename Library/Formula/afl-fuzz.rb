class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.09b.tgz"
  sha256 "f3de3717006f1204ad552a86546a84030a55bb0f17a2d78aadda73798cdb5eeb"

  bottle do
    sha256 "5921bb76782205c457c737d94fb98b3ff1b6b2c5705e4121b13cd53e1b43d303" => :el_capitan
    sha256 "616acd938988bf37e38d1b3f9f0faed577a2470af8d15a492c6fcf1732f07445" => :yosemite
    sha256 "685be81556badffa5ef69a53eb2ba58a073c713ffdb45c1df4f3c447898c533f" => :mavericks
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
