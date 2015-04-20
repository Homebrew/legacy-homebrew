require "formula"

class AflFuzz < Formula
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-1.71b.tgz"
  sha256 "e8418b16e205499a1e89c37cbddddaba5299709a023cdc5bf8cff414139ab088"

  head "http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz"

  bottle do
    sha256 "137f138da363365fa087a56e0e64fb8e487e0051a46c6d8b9fb751f5c765c1c2" => :yosemite
    sha256 "053e85622085ba81c3b46690adbc411b7e35e9e77da6c2b77a4efb7a52d03bd9" => :mavericks
    sha256 "7f74c656f5f5410bf4fa60784311d8ce295f892f01774c7561504e79b08b437c" => :mountain_lion
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
