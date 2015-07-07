require "formula"

class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.13.1.tar.gz"
  sha1 "9595586fb30c6baab6893b0d3fcbbb8719ab41ae"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha256 "760132d9c71d6b835bf089f3c05f4f6112f2e77dcde9492e33fba54fa9ccbc79" => :yosemite
    sha256 "42cddabfd6154b756c6b8bef0c93dfe7063c04608e10d7ad1b6976d36df77200" => :mavericks
    sha256 "b4153ae98a7ea82b6091e88dbd89a7bd4e4931e6e1af332c2638f8b71f45f288" => :mountain_lion
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
