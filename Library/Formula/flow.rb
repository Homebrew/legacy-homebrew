class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.20.1.tar.gz"
  sha256 "0b2f7fc1eaa15c6ed8f39ddfd7f94e758e52b805c43efcf45d5acce6057eb705"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "433ddfe4ac21fbdb78bcdb0760a0a8fabfcf4e82018b44223e4d88fe727e30ef" => :el_capitan
    sha256 "47e5d81632dc8c09bb3b3913aa9f6e02623ce4bff93c266f876969550569d48d" => :yosemite
    sha256 "ab356f775c20d6721f028b44334415187ee0e9159e1d0079d9a07fbbaf00531f" => :mavericks
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
