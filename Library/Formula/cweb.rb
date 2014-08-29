require "formula"

class Cweb < Formula
  homepage "http://www-cs-faculty.stanford.edu/~uno/cweb.html"
  url "ftp://ftp.cs.stanford.edu/pub/cweb/cweb-3.64ad.tar.gz"
  sha1 "a9828b66b525d7cf91c57b3c4891168caa4af10a"

  bottle do
    sha1 "ab57d1005e2c2c9fddd67b4260d37f791deed5c0" => :mavericks
    sha1 "9b83fb6b84de445f4d58997c710f291b9cbdc696" => :mountain_lion
    sha1 "953b5d5ae51745f8664ffd5998819d60f1d58189" => :lion
  end

  def install
    ENV.deparallelize

    macrosdir = (share/"texmf/tex/generic")
    emacsdir = (share/"emacs/site-lisp")
    cwebinputs = (lib/"cweb")

    # make install doesn't use `mkdir -p` so this is needed
    [bin, man1, macrosdir, emacsdir, cwebinputs].each do |path|
        path.mkpath
    end

    system "make", "install",
      "DESTDIR=#{bin}/",
      "MANDIR=#{man1}",
      "MANEXT=1",
      "MACROSDIR=#{macrosdir}",
      "EMACSDIR=#{emacsdir}",
      "CWEBINPUTS=#{cwebinputs}"
  end

  test do
    (testpath/"test.w").write <<-EOS.undent
      @* Hello World
      This is a minimal program written in CWEB.

      @c
      #include <stdio.h>
      void main() {
          printf("Hello world!");
      }
    EOS
    system bin/"ctangle", "test.w"
    system ENV.cc, "test.c", "-o", "hello"
    assert_equal "Hello world!", `./hello`
  end
end
