require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.5.10.tar.gz"
  sha256 "a83b099e4fcccc886dcbbd4e9400f68c04ad0385f3b24b1a454e2fbf4bba5e41"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    sha256 "1191b0ff23a78058a6b85c66c1f0d0715c8894e242d7e760d49c9e146324e974" => :el_capitan
    sha256 "54ffbd47e3f17bcc14910d66104e843f532cd982767e9005c5542e2fbaa4936b" => :yosemite
    sha256 "2463d1e60d5f57a4d141eae5ca204a2c844096f79b5fc1a434a081bdbb4713c8" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pcre"

  def install
    install_cabal_package
  end

  test do
    path = testpath/"test.rb"
    path.write <<-EOS.undent
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --comment test #{path}")
    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --literal test #{path}")
    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --code puts #{path}")
  end
end
