require "formula"
require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.4.9.tar.gz"
  sha1 "0b5bc5bb96b2c70a7353ac036ce5949bbe2a9bc1"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    cellar :any
    sha1 "08b871722472f4d2ee246ca59cf9266e7f37f78a" => :yosemite
    sha1 "cd182ff755db1210bba15dce69d5cf90acfa9e82" => :mavericks
    sha1 "57d998d3e8dfc19fc7d9fdb67e9ebf92e9e5ed26" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  def install
    install_cabal_package
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
