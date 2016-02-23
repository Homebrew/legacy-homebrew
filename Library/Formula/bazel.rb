class Bazel < Formula
  desc "Google's own build tool"
  homepage "http://bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.2.0.tar.gz"
  sha256 "3685ce039e44224260a7ed5b80dd951155998a6e128b2bebe984ea1d85a674b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e850a43faf41b0b87387f4302d13d758235252a7e49c711fe47cb7b82c3141a" => :el_capitan
    sha256 "7d7de14b9d1e1f7693b22cf043c2b822c23a869f75bc7dd29b29f86177330b63" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"

    system "./compile.sh"
    system "./output/bazel", "build", "scripts:bash_completion"

    bin.install "output/bazel" => "bazel"
    bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
    zsh_completion.install "scripts/zsh_completion/_bazel"
  end

  test do
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<-EOS.undent
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    EOS

    (testpath/"BUILD").write <<-EOS.undent
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    EOS

    system "#{bin}/bazel", "build", "//:bazel-test"
    system "bazel-bin/bazel-test"
  end
end
