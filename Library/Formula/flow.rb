require "formula"

class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.12.0.tar.gz"
  sha1 "fd8edf6cf291d66bc20053dd02eb66507f36023a"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha256 "fd20aff1d786aadebfd990ed571b0cca8d93083a8bda89245a89f5ac9dd70a55" => :yosemite
    sha256 "16516306bae3cb264733f706fbb6ea5ede2b25d7aedc32a21663964741e62417" => :mavericks
    sha256 "2a6fc52ef06dbce0bb65f3ffb4022681e3ccfca67526f86cc5e36e87ce2d4de5" => :mountain_lion
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
