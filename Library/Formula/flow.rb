class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.18.1.tar.gz"
  sha256 "6634a92cfe75d344060d856b4de69d345aa9fde1b39a1f7988e74e59e1d6b9e8"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e80b9010d380c905fdcb4f105c7e48929a9299ce5c8f23fe272dfeabb65749ca" => :el_capitan
    sha256 "de205376d6bc7bf6244ff40bbc8687964e46a30ec7954da69a65bfbe524bede7" => :yosemite
    sha256 "21b45ba6e461ef0a79215959b81dcc58db1635963dad09e533b29ea20c963746" => :mavericks
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
