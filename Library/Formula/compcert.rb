require "formula"

class Compcert < Formula
  homepage "http://compcert.inria.fr"
  url "http://compcert.inria.fr/release/compcert-2.1.tgz"
  sha1 "1ec21e43c3ac778827522d385733e36d24c5f8d4"

  depends_on "coq" => :build
  depends_on "objective-caml" => :build
  depends_on "camlp5" => :build

  def install
    # Compcert's configure script hard-codes gcc. On Lion and under, this
    # creates problems since XCode's gcc does not support CFI,
    # but superenv will trick it into using clang which does. This
    # causes problems with the compcert compiler at runtime.
    inreplace 'configure', '${toolprefix}gcc', "${toolprefix}#{ENV.cc}"

    system "./configure", "-prefix", prefix, "ia32-macosx"
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      int main(int argc, char** argv) {
        printf("Hello, world!\n");
        return 0;
      }
    EOS
    system "#{bin}/ccomp", "test.c", "-o", "test"
    system "./test"
  end
end
