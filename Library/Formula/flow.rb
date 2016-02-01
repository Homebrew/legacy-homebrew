class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.21.0.tar.gz"
  sha256 "6e367334193f4785da0c96bd1d82937a8336cd0f65bbaa2b8fcb8e6a2fcfe69f"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fc3645f0463ca258c6ee32a39c65aaf1cabe9ebae9d0ddac454b6e70a440f92" => :el_capitan
    sha256 "0bc223e406e920b7c8ae01df955dd19f2e0276c700ccef5869e314edccc8a99a" => :yosemite
    sha256 "093e1283b36d0184f2f7c3b0e387a95ec3dffc40b1d38a12d5375112739d06d5" => :mavericks
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
