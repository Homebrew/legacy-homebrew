require "formula"

class Ngrok < Formula
  homepage "https://ngrok.com"
  url "https://github.com/inconshreveable/ngrok/archive/1.6.tar.gz"
  sha1 "03d076bfe078ebe52c0c81dfa1e49b497e7295fa"

  head "https://github.com/inconshreveable/ngrok.git", :branch => "master"

  depends_on "bazaar" => :build
  depends_on "go" => :build
  depends_on :hg => :build

  def install
    system "make", "release-client"
    bin.install "bin/ngrok"
  end

  test do
    system "#{bin}/ngrok", "version"
  end
end
