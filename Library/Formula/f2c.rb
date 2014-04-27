require 'formula'

class F2c < Formula
  homepage 'http://www.netlib.org/f2c/'
  url 'http://netlib.sandia.gov/cgi-bin/netlib/netlibfiles.tar?filename=netlib/f2c'
  sha1 '4471b777826e7b97c5dfbb89b8c245043ef7bd1c'
  version '20130926'

  def install

    system "unzip", "libf2c.zip", "-d", "libf2c"
    # f2c header and libf2c.a
    cd "libf2c" do
      system "make", "-f", "makefile.u", "f2c.h"
      include.install "f2c.h"

      system "make", "-f", "makefile.u"
      lib.install "libf2c.a"
    end

    # f2c executable
    cd "src" do
      system "make", "-f", "makefile.u", "f2c"
      bin.install "f2c"
    end

    # man pages
    man1.install "f2c.1t"
  end

  test do
    # check if executable doesn't error out
    system "#{bin}/f2c", "--version"

    # hello world test
    (testpath/"test.f").write <<-EOS.undent
    C comment line
          program hello
          print*, 'hello world'
          stop
          end
    EOS
    system "#{bin}/f2c", "test.f"
    assert (testpath/"test.c").exist?
    system "cc", "-O", "-o", "test", "test.c", "-lf2c"
    assert_equal " hello world\n", `#{testpath}/test`
  end
end
