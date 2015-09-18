class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.16.0.tar.gz"
  sha256 "1a79eca9d5134bf3e62132aa59643f15aa03a993d4eaba7f0bd0627ba69566f7"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f31239cce34c4efe02b90135b07194843d2d5b37b01f43d943f6490c1be41ec1" => :el_capitan
    sha256 "b0353dd4be1ede7d94a1af896ebf298fea283f59605377d69d396c7fd7de0cbe" => :yosemite
    sha256 "98f3ed29075b0b3cc457dc722d7ad38f4ba9c84dd3a60df1e43d1afe29478428" => :mavericks
    sha256 "6cc6fdcd50bfe4f39397902a1dbc31a65e242a4ca76cb918e395cd97d8d35eac" => :mountain_lion
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
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
