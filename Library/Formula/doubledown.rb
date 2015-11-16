class Doubledown < Formula
  desc "Sync local changes to a remote directory"
  homepage "https://github.com/devstructure/doubledown"
  url "https://github.com/devstructure/doubledown/archive/v0.0.2.tar.gz"
  sha256 "47ff56b6197c5302a29ae4a373663229d3b396fd54d132adbf9f499172caeb71"
  head "https://github.com/devstructure/doubledown.git"

  bottle :unneeded

  def install
    bin.install Dir["bin/*"]
    man1.install Dir["man/man1/*.1"]
  end
end
