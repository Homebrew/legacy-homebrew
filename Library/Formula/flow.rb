class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.14.0.tar.gz"
  sha256 "1dab6ca03966e9ddc0a22220b56df55997e9ec26bdc795ca4ba7db9b1c76a376"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    revision 1
    sha256 "4a98a4f86ee69e8e20533d55bad144f0350fee215f69208107256079f6e33bc6" => :yosemite
    sha256 "f15b160c6c831e63e67b40e02b84c917df59bc255e958ec107e001b0301bcd00" => :mavericks
    sha256 "e2ebbc4a28a9c460194b738b7fe5a1933674ae21ba520ddaf0485c3f520532e3" => :mountain_lion
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
