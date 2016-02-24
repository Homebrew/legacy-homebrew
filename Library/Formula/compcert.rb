class Camlp5TransitionalModeRequirement < Requirement
  fatal true

  satisfy(:build_env => false) { !Tab.for_name("camlp5").with?("strict") }

  def message; <<-EOS.undent
    camlp5 must be compiled in transitional mode (instead of --strict mode):
      brew install camlp5
    EOS
  end
end

class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v2.6.tar.gz"
  sha256 "a1f21365c41c2462fce52a4a25e1c7e4b7fea7a0cd60b6bae1d31f2edeeb4d17"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f0f88dc58d3beacc0f1534966b71f16de0fa46ef92bd5bb1803b666395363b58" => :el_capitan
    sha256 "a266c0316f33643e39f7608202823fdb1d61df60333e85d888ceeeae47e96772" => :yosemite
    sha256 "2df9fcb4ad87d751ddd67109e0d68741ba15317f14ba726db03c329237d6983f" => :mavericks
  end

  depends_on "ocaml" => :build
  depends_on "menhir" => :build
  depends_on "camlp5" => :build # needed for building Coq 8.4
  depends_on Camlp5TransitionalModeRequirement # same requirement as in Coq formula

  # Should be removed as soon as CompCert gets Coq 8.5 support
  resource "coq84" do
    url "https://coq.inria.fr/distrib/V8.4pl6/files/coq-8.4pl6.tar.gz"
    sha256 "a540a231a9970a49353ca039f3544616ff86a208966ab1c593779ae13c91ebd6"
  end

  def install
    resource("coq84").stage do
      system "./configure", "-prefix", buildpath/"coq84",
                            "-camlp5dir", Formula["camlp5"].opt_lib/"ocaml/camlp5",
                            "-coqide", "no",
                            "-with-doc", "no"
      ENV.deparallelize do
        system "make", "world"
        system "make", "install"
      end
    end

    ENV.prepend_path "PATH", buildpath/"coq84/bin"
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
