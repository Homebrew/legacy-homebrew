class Bazel < Formula
  desc "Google's own build tool"
  homepage "http://bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.2.1.tar.gz"
  sha256 "be964f98480ed258f249fc44c467a293e3a143aa750149b970da3d6719ba6ff1"

  bottle do
    cellar :any_skip_relocation
    sha256 "33e512a0e8f97f6fa95e3134317cd385f3447ab83b90fc09e31db52b0c646d05" => :el_capitan
    sha256 "7b5e0bd6824200bbbb0943205c6c5021b5448476f7923b9aaf6e3542ab937206" => :yosemite
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
