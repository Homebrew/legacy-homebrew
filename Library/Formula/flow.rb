class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.22.0.tar.gz"
  sha256 "12c0ae94fbf95913f3ce522d07531a1f8b15678cdbfe14300d78d7d0ff997bef"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99d667a30b2c44f943e2fef2a7407be4d2066984d275998195ce95768469168d" => :el_capitan
    sha256 "1cc3b42f3938d7dcf3f04c989904b1ab400a5d8e61eceaece5ad6e4fe1d6edac" => :yosemite
    sha256 "fca142de488ad45a8672cd0559d317ee55680bd00d8041e0bbd8e0935b32ee2a" => :mavericks
  end

  depends_on "ocaml" => :build

  def install
    system "make"
    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<-EOS.undent
      /* @flow */
      var x: string = 123;
    EOS
    expected = /number\nThis type is incompatible with\n.*string\n\nFound 1 error/
    assert_match expected, shell_output("#{bin}/flow check --old-output-format #{testpath}", 2)
  end
end
