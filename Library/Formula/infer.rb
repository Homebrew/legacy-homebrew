class Infer < Formula
  desc "Static analyzer for Java, C and Objective-C"
  homepage "http://fbinfer.com/"
  url "https://github.com/facebook/infer/releases/download/v0.6.0/infer-osx-v0.6.0.tar.xz"
  sha256 "8a1c4d0425c0ef3efcf4683cdbeebba63f3dd2fd5e75df4f04142dc9a5a5f15d"

  bottle do
    cellar :any
    sha256 "e0c9f221329f7f7366107225ce41543a1ca7c529079d89f713a0d3287c9d33fe" => :el_capitan
    sha256 "0555b2cfaa38c812364646bd0fe743d11202189beab510277acba8a7b748add7" => :yosemite
    sha256 "273243d66f0f3bb3d1fcc6e552523e59f36a06c99c7b770fd3b9bbda4b2b6fe3" => :mavericks
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
