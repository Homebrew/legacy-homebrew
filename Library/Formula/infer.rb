class Infer < Formula
  desc "Static analyzer for Java, C and Objective-C"
  homepage "http://fbinfer.com/"
  url "https://github.com/facebook/infer/releases/download/v0.5.0/infer-osx-v0.5.0.tar.xz"
  sha256 "6a8547ac0b75a5e2bbeccae2169e39f753a60adbcacb6c94599fd31343a71ce7"

  bottle do
    cellar :any
    sha256 "e4ef852bc85675803f4f5a0f2cca5972ea33d3947c5f0e01195d53126ea49b79" => :el_capitan
    sha256 "f3049600231d142851d0b35ea161de5e7053abc1d9ba78bf45f07addb2298745" => :yosemite
    sha256 "8cac200ab4fff43b90c75f20ab5a66889a9c25b525763e65e1fd8daf8ded8375" => :mavericks
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
