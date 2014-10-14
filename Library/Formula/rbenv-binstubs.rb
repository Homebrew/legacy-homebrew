require "formula"

class RbenvBinstubs < Formula
  homepage "https://github.com/ianheggie/rbenv-binstubs"
  url "https://github.com/ianheggie/rbenv-binstubs/archive/v1.4.tar.gz"
  sha1 "7bea29d60e6b3870608c056c6f0ebf55bb8a150a"

  head "https://github.com/ianheggie/rbenv-binstubs.git"

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end
end
