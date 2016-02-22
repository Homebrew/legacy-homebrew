class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.22.0.tar.gz"
  sha256 "12c0ae94fbf95913f3ce522d07531a1f8b15678cdbfe14300d78d7d0ff997bef"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "283956a19eea42c7a14fc1f19eb6f86ca54a9ffc908cc661e63449a403cc33d3" => :el_capitan
    sha256 "c9091527f23d2d079984e5170e4b1016d752362e4f2a06b5b11a5740196955dd" => :yosemite
    sha256 "243f97dc47f2ba5305899b45ec77cab398fa804b8424457c9c9bd61d4460b9ff" => :mavericks
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
