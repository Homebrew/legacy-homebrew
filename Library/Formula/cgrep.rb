require "formula"
require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.4.4.tar.gz"
  sha1 "d36eef5d93e660df971a9f74d4ffff6ed6fab710"
  head "https://github.com/awgn/cgrep.git", :branch => "master"
  revision 1

  bottle do
    cellar :any
    sha1 "80b896667bd0a76b3516c404075836100549224b" => :mavericks
    sha1 "bf5bc875771842ad4d3553274642fde85c358aef" => :mountain_lion
    sha1 "a7051c177a0fc04706c21066a6db20a7876ed13c" => :lion
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
