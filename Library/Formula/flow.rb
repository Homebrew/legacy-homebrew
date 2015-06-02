require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.11.0.tar.gz"
  sha1 "714ad08030aab07acf76bf4b6c2603a8b193881d"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha256 "031eb5ac7f75e6e7a12c038543764012dd91cae67a185b61cdc20059b0b4ab6d" => :yosemite
    sha256 "e16e00a1d182c84c9eddfd57bf8e72974d6704710f70b821506c63d5ce373ae0" => :mavericks
    sha256 "95fa7f28d058a7c3e0ce2b0fa33da6166718f5412473d8f7bbebbef2b4f8439b" => :mountain_lion
  end

  depends_on "objective-caml" => :build

  def install
    system "make"
    bin.install "bin/flow"
    (share/"flow").install "bin/examples"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    output = `#{bin}/flow single #{share}/flow/examples/01_HelloWorld`
    assert_match(/This type is incompatible with/, output)
    assert_match(/Found 1 error/, output)
  end
end
