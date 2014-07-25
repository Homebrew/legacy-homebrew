require "formula"
require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.4.4.tar.gz"
  sha1 "d36eef5d93e660df971a9f74d4ffff6ed6fab710"
  head "https://github.com/awgn/cgrep.git", :branch => "master"

  bottle do
    cellar :any
    sha1 "422737ceaee66f521d60c163dcf663d25c2b430a" => :mavericks
    sha1 "e986ec29104895e0554c3599ac8eebcc6914a67d" => :mountain_lion
    sha1 "660b2e1d0f6d15e6d7294a464d26b866bcd0030b" => :lion
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
