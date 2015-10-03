class Gimme < Formula
  desc "Shell script to install any Go version"
  homepage "https://github.com/travis-ci/gimme"
  url "https://github.com/travis-ci/gimme/archive/v0.2.4.tar.gz"
  sha256 "feb9c25d96cc6a4e735200a180070ec3458fea7d1795439abf8acad45edfc194"

  def install
    bin.install "gimme"
  end

  test do
    system "#{bin}/gimme", "-l"
  end
end
