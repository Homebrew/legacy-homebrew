class Bazel < Formula
  desc "Google's own build tool"
  homepage "http://bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.1.1.tar.gz"
  sha256 "49d11d467cf9e32dea618727198592577fbe76ff2e59217c53e3515ddf61cd95"

  bottle do
    cellar :any
    sha256 "8b65246774756d31cc97f29bddc6de705ca2fc9517d7a9d997e21aacad39855b" => :el_capitan
    sha256 "35f5743ed99b97df7a41b489d61677e8ea337d7eb04f95a1ff8089da60adca62" => :yosemite
    sha256 "ca1cd3f07bfe772cea1ce8e307891adb26081fc0012d5d9f438306ca36a52fef" => :mavericks
  end

  depends_on :java => "1.8+"

  def install
    # Replace the default system wide rc path to
    # /usr/local/etc/bazel/bazel.bazelrc
    inreplace "src/main/cpp/blaze_startup_options.cc",
      "/etc/bazel.bazelrc",
      "#{etc}/bazel/bazel.bazelrc"

    system "./compile.sh"

    (prefix/"base_workspace").mkdir
    cp_r Dir["base_workspace/*"], (prefix/"base_workspace"), :dereference_root => true
    bin.install "output/bazel" => "bazel"
    (prefix/"etc/bazel.bazelrc").write <<-EOS.undent
      build --package_path=%workspace%:#{prefix}/base_workspace
      query --package_path=%workspace%:#{prefix}/base_workspace
      fetch --package_path=%workspace%:#{prefix}/base_workspace
    EOS
    (etc/"bazel").install prefix/"etc/bazel.bazelrc"
  end

  test do
    (testpath/"WORKSPACE").write("")

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
