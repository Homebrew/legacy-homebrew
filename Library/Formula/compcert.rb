class Compcert < Formula
  desc "CompCert C verified compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v2.5.tar.gz"
  sha256 "36847b00fa5436ac8e052489b728adef2bc68064fe22dbdc18bf22256856fd95"

  bottle do
    cellar :any
    sha256 "c5868acdb43b5c467e4e969b665b8775b8065454c339ef98e56034230b24750f" => :yosemite
    sha256 "eb646e83d7be1cc4e0b5e426c9247a45d26906de3f06c39e2e0451c4849b59ba" => :mavericks
    sha256 "7ce52bcd1e488829d71481741f49abd3489b9b86e2f400825de439a730d3ba2b" => :mountain_lion
  end

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
