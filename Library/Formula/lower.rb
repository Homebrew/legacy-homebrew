require "formula"

class Lower < Formula
  homepage "https://github.com/shoma2da/homebrew-lower"
  url "https://github.com/shoma2da/homebrew-lower.git", :tag => "1.0.0"
  sha1 "bb0de35104e9f0a3f2afc9713fda10f496422a51"

  skip_clean 'bin'

  def install
    prefix.install 'bin'
    bin.chmod 0755
  end
end
