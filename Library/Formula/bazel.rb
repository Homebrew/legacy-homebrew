class Bazel < Formula
  desc "Google's own build tool"
  homepage "http://bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.1.3.tar.gz"
  sha256 "5ba3e69b0867e00c3c765b499a5e836db791e3f2f5112f5684782eef5bab0218"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "ad4cf72bdba2f232c774ef82e3d92301fe5643b9ccc0fc4fbf1403af47550953" => :el_capitan
    sha256 "9baaf779a175f09dbfc280411c18a9ecfa903efa431bfbfe40ec72cec42f8b6b" => :yosemite
    sha256 "45ce34d6790be4334b90943e94c3771227556c8a59fb8c4375f77aad462c045f" => :mavericks
  end

  depends_on :java => "1.8+"

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
