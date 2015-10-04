require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.4.12.tar.gz"
  sha256 "a38d7957854b9b6f55ed8610d88b0ba3d5061d7194e3ec13e608d7a4515371f5"
  head "https://github.com/awgn/cgrep.git"

  revision 1

  bottle do
    sha256 "677084bcc353b3bfc75629c6b974027c34c7330b2ecabe8489462585fbd10159" => :yosemite
    sha256 "e8e7d72ed0db7ff54ec8bf6a08f4744135e2616df6360041736e26c8ff789668" => :mavericks
    sha256 "5721bb4900b6d0ff7f6eb40c40bafa56f7153206d6851dd66297cf64b1c178e9" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  setup_ghc_compilers

  def install
    # The "--allow-newer" is a hack for GHC 7.10.1, remove when possible.
    install_cabal_package "--allow-newer"
  end

  test do
    test_string = "String in"
    path = testpath/"test.rb"
    path.write <<-EOS.undent
      # puts #{test_string} comment.
      puts "#{test_string} literal."
    EOS

    comment = `cgrep --comment "#{test_string}" #{path}`
    assert_equal 1, comment.lines.count
    literal = `cgrep --literal "#{test_string}" #{path}`
    assert_equal 1, literal.lines.count
    code = `cgrep --code puts #{path}`
    assert_equal 1, code.lines.count
  end
end
