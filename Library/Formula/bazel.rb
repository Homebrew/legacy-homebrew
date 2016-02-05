class Bazel < Formula
  desc "Google's own build tool"
  homepage "http://bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.1.4.tar.gz"
  sha256 "7668dea0e3455cb10d0ac7b59e81de533edabea875fde77deb8d7a7bf24feaf4"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f2a2c5d3041fc41d39305073cb63a5744ec73d1e86cf71c6ff7bc73ec0f09ce" => :el_capitan
    sha256 "dcb6dbcb618acb7953ae217f121b54eda5887d70f1e0896fad489dc4a9dfbfc7" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite

  def install
    inreplace "src/main/cpp/blaze_startup_options.cc",
      "/etc/bazel.bazelrc",
      "#{etc}/bazel/bazel.bazelrc"

    ENV["EMBED_LABEL"] = "#{version}-homebrew"

    system "./compile.sh"
    system "./output/bazel", "build", "scripts:bash_completion"

    (prefix/"base_workspace").mkdir
    cp_r Dir["base_workspace/*"], (prefix/"base_workspace"), :dereference_root => true
    bin.install "output/bazel" => "bazel"
    (prefix/"etc/bazel.bazelrc").write <<-EOS.undent
      build --package_path=%workspace%:#{prefix}/base_workspace
      query --package_path=%workspace%:#{prefix}/base_workspace
      fetch --package_path=%workspace%:#{prefix}/base_workspace
    EOS
    (etc/"bazel").install prefix/"etc/bazel.bazelrc"

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
