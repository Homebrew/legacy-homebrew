class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.16.0.tar.gz"
  sha256 "1a79eca9d5134bf3e62132aa59643f15aa03a993d4eaba7f0bd0627ba69566f7"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a5c7f3dba8379c1159d1d4ce2e13f80c0cbcd4902ba9049368d5d435f2db7c5" => :el_capitan
    sha256 "c9a878f20179bbfb4550b576af69ff1eef259eebe38e4823f61fc715b01beb6a" => :yosemite
    sha256 "48830e9e7b9a9558c6ccae11a0214d45e75abbf39a416e2f8a73d545f2b5b821" => :mavericks
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
