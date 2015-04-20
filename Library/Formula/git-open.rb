require "formula"

class GitOpen < Formula
  homepage "https://github.com/jeffreyiacono/git-open"
  url "https://github.com/jeffreyiacono/git-open/archive/v1.1.tar.gz"
  sha1 "86a2a9b67e5fe20779b2ae7ad59a3450c7c72d23"

  def install
    bin.install "git-open.sh" => "git-open"
  end
end
