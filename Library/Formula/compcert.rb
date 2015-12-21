class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v2.5.tar.gz"
  sha256 "36847b00fa5436ac8e052489b728adef2bc68064fe22dbdc18bf22256856fd95"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f0f88dc58d3beacc0f1534966b71f16de0fa46ef92bd5bb1803b666395363b58" => :el_capitan
    sha256 "a266c0316f33643e39f7608202823fdb1d61df60333e85d888ceeeae47e96772" => :yosemite
    sha256 "2df9fcb4ad87d751ddd67109e0d68741ba15317f14ba726db03c329237d6983f" => :mavericks
  end

  depends_on "ocaml" => :build
  depends_on "coq" => :build
  depends_on "menhir" => :build

  def install
    ENV.permit_arch_flags

    # Compcert's configure script hard-codes gcc. On Lion and under, this
    # creates problems since Xcode's gcc does not support CFI,
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
