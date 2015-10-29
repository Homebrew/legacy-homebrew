require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.5.3.tar.gz"
  sha256 "8660a9459533d890504a416c2dfc06af672f90c0807745192f7daab8bdba3c82"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    sha256 "677084bcc353b3bfc75629c6b974027c34c7330b2ecabe8489462585fbd10159" => :yosemite
    sha256 "e8e7d72ed0db7ff54ec8bf6a08f4744135e2616df6360041736e26c8ff789668" => :mavericks
    sha256 "5721bb4900b6d0ff7f6eb40c40bafa56f7153206d6851dd66297cf64b1c178e9" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  setup_ghc_compilers

  def install
    install_cabal_package
  end

  test do
    test_string = "String in"
    (testpath/"test.rb").write <<-EOS.undent
      # puts #{test_string} comment.
      puts "#{test_string} literal."
    EOS

    assert_equal 1, shell_output("#{bin}/cgrep --literal \"#{test_string}\" #{testpath}/test.rb").lines.count
    assert_equal 1, shell_output("#{bin}/cgrep --code puts #{testpath}/test.rb").lines.count
  end
end
