class Bazel < Formula
  desc "Google's own build tool"
  homepage "http://bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.1.2.tar.gz"
  sha256 "e527db85d788e1ada244b2e530ce77a2b25784b361377b5e2ea679b5d341bd3a"

  bottle do
    cellar :any
    sha256 "90e36fc1e45c91a49e4b8cdf2491e635d0883192872f95e06a29493c45a361a2" => :el_capitan
    sha256 "630d1aff9b2cde2e53eaba4b5589ed5948ae5af492a11bf95e479cffe44d013f" => :yosemite
    sha256 "1084f2351cb2724d2e66b07839e9df5a6cdd3eae8fd6a6cf22ee850a1500f9db" => :mavericks
  end

  depends_on :java => "1.8+"

  def install
    # Replace the default system wide rc path to
    # /usr/local/etc/bazel/bazel.bazelrc
    inreplace "src/main/cpp/blaze_startup_options.cc",
      "/etc/bazel.bazelrc",
      "#{etc}/bazel/bazel.bazelrc"

    ENV["EMBED_LABEL"] = "#{version}-homebrew"

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
