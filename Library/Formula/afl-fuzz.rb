class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.09b.tgz"
  sha256 "f3de3717006f1204ad552a86546a84030a55bb0f17a2d78aadda73798cdb5eeb"

  bottle do
    sha256 "9f62b6c4a45272290e8bbcfcc59cea572c31c550f65e937379e914f662bf1ce6" => :el_capitan
    sha256 "394ad8b0ed3e29a14f3bab2db103d975bb2154e3ebb96dedf2828e365a998c52" => :yosemite
    sha256 "7f49e1032920758ce2b9a2882efdd212a7b62029f54f70b1e305389158c36705" => :mavericks
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
