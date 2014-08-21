require "formula"
require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.4.6.tar.gz"
  sha1 "e177e200b2f94d18bf9de614695dfe2c8d37638f"
  head "https://github.com/awgn/cgrep.git", :branch => "master"

  bottle do
    cellar :any
    sha1 "919ba2c2b997dfff0495e5f57a7005b52b22c10f" => :mavericks
    sha1 "dc0620015683c5cc15eb0f960a7d757097615d6d" => :mountain_lion
    sha1 "21db5a8f58aa73d5a85ecc04c7b6da680975fde5" => :lion
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
