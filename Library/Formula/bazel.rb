class Bazel < Formula
  desc "Google's own build tool"
  homepage "http://bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.1.1.tar.gz"
  sha256 "49d11d467cf9e32dea618727198592577fbe76ff2e59217c53e3515ddf61cd95"

  bottle do
    cellar :any
    revision 1
    sha256 "4e2ceee3d1a79339ab90377352b93631960bf4599853cea765116e7e6d0bc4ff" => :el_capitan
    sha256 "63396e0919c7034ce3a6fd0a91567f1ffcd352a2b62230f7177d74d5be49d992" => :yosemite
    sha256 "75f9ed1b50fef939e5806818835205fe11f4494bfe0aeb65ddfb4a8a1763146a" => :mavericks
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
