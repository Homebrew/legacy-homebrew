require "formula"

class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.11.0.tar.gz"
  sha1 "714ad08030aab07acf76bf4b6c2603a8b193881d"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    revision 1
    sha256 "6e099b230e6daaaf57f365d5a5c054d83279deaeb5144612ab427498fe9ec980" => :yosemite
    sha256 "5737613181baca6a3659d98f8745c0525685067fa327ba48c0a595f3cd5550dc" => :mavericks
    sha256 "f364b3e00ec533ca5189a3ea9583c9b2d8e89437a0368674cf0774d90fa65b8d" => :mountain_lion
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
