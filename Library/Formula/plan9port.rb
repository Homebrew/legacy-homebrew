require "formula"

class Plan9port < Formula
  homepage "http://swtch.com/plan9port/"
  url "https://plan9port.googlecode.com/files/plan9port-20140123.tgz"
  sha1 "0b207cdaac9df2dd1ae7f8e156c4ffcc625d594c"

  def install
    ENV["PLAN9_TARGET"] = libexec
    system "./INSTALL"

    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/9"]
    prefix.install Dir["#{libexec}/mac/*.app"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <u.h>
      #include <libc.h>
      #include <stdio.h>

      int main(void) {
        return printf("Hello World\\n");
      }
    EOS
    system "#{bin}/9", "9c", "test.c"
    system "#{bin}/9", "9l", "-o", "test", "test.o"
    assert_equal "Hello World\n", `./test`
  end
end
