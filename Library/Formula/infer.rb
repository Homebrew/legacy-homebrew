class Infer < Formula
  desc "Static analyzer for Java, C and Objective-C"
  homepage "http://fbinfer.com/"
  url "https://github.com/facebook/infer/releases/download/v0.8.0/infer-osx-v0.8.0.tar.xz"
  sha256 "2b494a2b595bd7cf0f0cfaac4e9bece568575a4bcf25cc00161ed34c0319dc58"

  bottle do
    cellar :any
    sha256 "d68afde0015e7c9caa125ffd2add4d83efafad8ba162692b270eb348e366a88a" => :el_capitan
    sha256 "a844603860e292d71598758edb79cc0c464914827b7fddce8c7ac41a8ef5e7e8" => :yosemite
    sha256 "d017795e3d39afef689598197f97bbcf208143d66281cd86e08d8ca56cadbd02" => :mavericks
  end

  option "without-clang", "Build without C/Objective-C analyzer"
  option "without-java", "Build without Java analyzer"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "opam" => :build

  def install
    if build.without?("clang") && build.without?("java")
      odie "infer: --without-clang and --without-java are mutually exclusive"
    end

    opamroot = buildpath/"build"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--no-setup"
    system "opam", "update"

    system "opam", "install", "ocamlfind"
    system "opam", "install", "sawja>=1.5.1"
    system "opam", "install", "atdgen>=1.6.0"
    system "opam", "install", "extlib>=1.5.4"
    system "opam", "install", "oUnit>=2.0.0"

    target_platform = if build.without?("clang")
      "java"
    elsif build.without?("java")
      "clang"
    else
      "all"
    end
    system "./build-infer.sh", target_platform, "--yes"

    rm "infer/tests/.inferconfig"
    libexec.install "facebook-clang-plugins" if build.with?("clang")
    libexec.install "infer"

    bin.install_symlink libexec/"infer/bin/infer"
  end

  test do
    (testpath/"FailingTest.c").write <<-EOS.undent
      #include <stdio.h>

      int main() {
        int *s = NULL;
        *s = 42;

        return 0;
      }
    EOS

    (testpath/"PassingTest.c").write <<-EOS.undent
      #include <stdio.h>

      int main() {
        int *s = NULL;
        if (s != NULL) {
          *s = 42;
        }

        return 0;
      }
    EOS

    shell_output("#{bin}/infer --fail-on-bug -- clang FailingTest.c", 2)
    shell_output("#{bin}/infer --fail-on-bug -- clang PassingTest.c", 0)

    (testpath/"FailingTest.java").write <<-EOS.undent
      class FailingTest {

        String mayReturnNull(int i) {
          if (i > 0) {
            return "Hello, Infer!";
          }
          return null;
        }

        int mayCauseNPE() {
          String s = mayReturnNull(0);
          return s.length();
        }
      }
    EOS

    (testpath/"PassingTest.java").write <<-EOS.undent
      class PassingTest {

        String mayReturnNull(int i) {
          if (i > 0) {
            return "Hello, Infer!";
          }
          return null;
        }

        int mayCauseNPE() {
          String s = mayReturnNull(0);
          return s == null ? 0 : s.length();
        }
      }
    EOS

    shell_output("#{bin}/infer --fail-on-bug -- javac FailingTest.java", 2)
    shell_output("#{bin}/infer --fail-on-bug -- javac PassingTest.java", 0)
  end
end
