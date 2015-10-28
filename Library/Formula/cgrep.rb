require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.5.10.tar.gz"
  sha256 "a83b099e4fcccc886dcbbd4e9400f68c04ad0385f3b24b1a454e2fbf4bba5e41"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    sha256 "677084bcc353b3bfc75629c6b974027c34c7330b2ecabe8489462585fbd10159" => :yosemite
    sha256 "e8e7d72ed0db7ff54ec8bf6a08f4744135e2616df6360041736e26c8ff789668" => :mavericks
    sha256 "5721bb4900b6d0ff7f6eb40c40bafa56f7153206d6851dd66297cf64b1c178e9" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pcre"

  setup_ghc_compilers

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
