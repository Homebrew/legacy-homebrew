class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.19.1.tar.gz"
  sha256 "172513a5f8fb785b05c408cdfef4a7b4ca31fdfa8e77e88c506ce5a9849a0f3f"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "443b433019fbd5b0cad6fa1288328ad3bb03ef68d7850ba11a909cf7213f9eab" => :el_capitan
    sha256 "6b5b3548ce35acfad6690f2aeaf74b0c1886e0d3c67cef713fd34dc69db66fb7" => :yosemite
    sha256 "5d349b616fea1a70724a6cf176b5e39265b7f6aa0a07aeb499eadce02618e8a5" => :mavericks
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
