require 'formula'

class Redpen < Formula
  homepage "http://redpen.cc/"
  url "https://github.com/recruit-tech/redpen/releases/download/v1.0-experimental-1/redpen-cli-1.0-assembled.tar.gz"
  sha1 "7441d916dd7ebf73e2f4334496687270a3843d15"

  depends_on :java => "1.8"

  def install
    libexec.install %w[bin lib]
    bin.install_symlink libexec+'bin/redpen'
  end
end
