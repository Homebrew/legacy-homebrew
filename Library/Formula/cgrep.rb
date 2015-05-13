require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.4.12.tar.gz"
  sha256 "a38d7957854b9b6f55ed8610d88b0ba3d5061d7194e3ec13e608d7a4515371f5"
  head "https://github.com/awgn/cgrep.git"

  revision 1

  bottle do
    cellar :any
    sha1 "f3879496816cd421a874c0c13f11749c2816bccc" => :yosemite
    sha1 "935e68c7447007ddcffe49f48c4ceb9bab69a362" => :mavericks
    sha1 "a446389f7b1977bf49b7ede278e731934659a647" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

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
