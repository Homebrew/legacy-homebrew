require "formula"

class Compcert < Formula
  homepage "http://compcert.inria.fr"
  url "http://compcert.inria.fr/release/compcert-2.3pl2.tgz"
  sha1 "8d7b9d5b18bd52487686db2acd534c978b1e1421"
  version "2.3pl2"

  depends_on "objective-caml" => :build
  depends_on "coq" => :build
  depends_on "menhir" => :build

  def install
    ENV.permit_arch_flags

    # Compcert's configure script hard-codes gcc. On Lion and under, this
    # creates problems since XCode's gcc does not support CFI,
    # but superenv will trick it into using clang which does. This
    # causes problems with the compcert compiler at runtime.
    inreplace "configure", "${toolprefix}gcc", "${toolprefix}#{ENV.cc}"

    system "./configure", "-prefix", prefix, "ia32-macosx"
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int printf(const char *fmt, ...);
      int main(int argc, char** argv) {
        printf("Hello, world!\\n");
        return 0;
      }
    EOS
    system "#{bin}/ccomp", "test.c", "-o", "test"
    system "./test"
  end
end
