class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.17.0.tar.gz"
  sha256 "282ead8e8a344e44b825b2f8727520fb420e79f76ed1c26fa3a137c8a0172b35"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84d9a7e6d96717ec1b690db3fdaf0a4e9eeca55c69c1dce9fb42ae36847fba21" => :el_capitan
    sha256 "4b48d4f2c96d32981a0b3c6166577c933753a101b2bd66e4360fdb20a03cf788" => :yosemite
    sha256 "0c9400ae1453ae86e47169f25a58dd892ed28e412d70d4859be8cfc91ae573da" => :mavericks
  end

  depends_on "ocaml" => :build

  def install
    system "make"
    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow init #{testpath}"
    (testpath/"test.js").write <<-EOS.undent
      /* @flow */
      var x: string = 123;
    EOS
    expected = /number\nThis type is incompatible with\n.*string\n\nFound 1 error/
    assert_match expected, shell_output("#{bin}/flow check --old-output-format #{testpath}", 2)
  end
end
