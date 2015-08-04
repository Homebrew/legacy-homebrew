class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.14.0.tar.gz"
  sha256 "1dab6ca03966e9ddc0a22220b56df55997e9ec26bdc795ca4ba7db9b1c76a376"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha256 "7bbc30b5d85436e3526be96ca00cbb61b8156ffda3016775da3a288134c1f4fa" => :yosemite
    sha256 "8e0117aeee3d0b670a7dc93aa60ccc09004eacb4d09b8aa4cc2e05e4ae091dc8" => :mavericks
    sha256 "5cf57fcca47de49144872145c9bb8b004c649f0ff12b1927573ddf821710275a" => :mountain_lion
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
