require "formula"

class Cweb < Formula
  homepage "http://www-cs-faculty.stanford.edu/~uno/cweb.html"
  url "ftp://ftp.cs.stanford.edu/pub/cweb/cweb-3.64ad.tar.gz"
  sha1 "a9828b66b525d7cf91c57b3c4891168caa4af10a"

  def install
    ENV.deparallelize

    system "make", "all"

    bin.install "ctangle"
    bin.install "cweave"
    man1.install "cweb.1"
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
    system "ctangle", "test.w"
    system ENV.cc, "test.c"
    assert_equal "Hello world!", `./a.out`
  end
end
