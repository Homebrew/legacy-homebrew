require "formula"

class Plan9port < Formula
  homepage "http://swtch.com/plan9port/"
  url "https://plan9port.googlecode.com/files/plan9port-20140306.tgz"
  sha1 "b778a96558e2b67be28ae80cab4482ef3082ec0e"

  def install
    ENV["PLAN9_TARGET"] = libexec
    system "./INSTALL"

    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/9"
    prefix.install Dir["#{libexec}/mac/*.app"]
  end

  def caveats; <<-EOS.undent
    In order not to collide with OSX system binaries, the Plan 9 binaries have
    been installed to #{libexec}/bin.
    To run the Plan 9 version of a command simply call it through the command
    "9", which has been installed into the Homebrew prefix bin.  For example,
    to run Plan 9's ls run:
        # 9 ls
    EOS
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
