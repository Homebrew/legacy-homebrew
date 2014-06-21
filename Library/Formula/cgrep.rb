require "formula"
require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.4.2.tar.gz"
  sha1 "209bc29721bcfdc5652839c54c89ceb2d5a86bf9"
  head "https://github.com/awgn/cgrep.git", :branch => "master"

  bottle do
    cellar :any
    sha1 "7c8b5399e4cbed0cf3e51565d7b009c70576c8e8" => :mavericks
    sha1 "cf0ebb3fb08a172a91645184458c3cf6bebfc981" => :mountain_lion
    sha1 "33a5fbe772ae2ffa7a5d3374a7304960053ee05d" => :lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

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
