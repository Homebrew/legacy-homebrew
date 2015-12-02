class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.19.0.tar.gz"
  sha256 "1fecc7280c481163a710411d2209a6a62efe34d41f0e5bce8c165e9dda052c8b"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e847713651d587eef0d191d7bf5e84fb5c15dd0f00f756e5e3aa3315241dcdd1" => :el_capitan
    sha256 "e842260b12a2690b32a23e7fef51406035f648cac4a451c88b81ff31b52f3127" => :yosemite
    sha256 "dc6fc1bb7289abfd5f24b17054dffd5f232f348592ca459bb9ac417d5258f62d" => :mavericks
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
