class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.22.1.tar.gz"
  sha256 "3ace90c42d82e7e32719b764d94e0bccb24620a22761a6f3ff7f3b28f2f37186"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49d422ce5c8d07f42dfcf5bb56757c511f9ac2ad3544f297d7ea011decef92a4" => :el_capitan
    sha256 "120011882ca47af5ca40fba9fe0659116815c5781306bbb8e8f36140ad4ca77f" => :yosemite
    sha256 "6f587c4ff72214f84ae803bef00f02b0f29d3325b444e38a1731440db6810478" => :mavericks
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
