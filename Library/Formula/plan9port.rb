class Plan9port < Formula
  desc "Many Plan 9 programs ported to UNIX-like operating systems"
  homepage "https://swtch.com/plan9port/"
  url "https://plan9port.googlecode.com/files/plan9port-20140306.tgz"
  sha256 "cbb826cde693abdaa2051c49e7ebf75119bf2a4791fe3b3229f1ac36a408eaeb"
  head "https://github.com/9fans/plan9port.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb56faa4c63a522e34ba609fc0d4eb5af9b22715c0915629776129eb64d8625f" => :el_capitan
    sha256 "86fd2ed15a0fe79927c04a064222f88455bfc0e72bc1f97576e2962b11a70cc8" => :yosemite
    sha256 "ef0059997655128f6b41faa1023b37a071ff9976f4c94d3b3bd706be65177aa1" => :mavericks
  end

  depends_on :x11 => :optional

  def install
    ENV["PLAN9_TARGET"] = libexec

    if build.with? "x11"
      # Make OS X system fonts available to Plan 9
      File.open("LOCAL.config", "a") do |f|
        f.puts "FONTSRV=fontsrv"
      end
    end

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
