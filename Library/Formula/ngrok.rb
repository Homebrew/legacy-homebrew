require "formula"

class Ngrok < Formula
  homepage "https://ngrok.com"
  url "https://github.com/inconshreveable/ngrok/archive/1.6.tar.gz"
  sha1 "03d076bfe078ebe52c0c81dfa1e49b497e7295fa"

  head "https://github.com/inconshreveable/ngrok.git", :branch => "master"

  bottle do
    sha1 "b6160dc85cbaccb43a739e3dea2a7b493c41aed1" => :mavericks
    sha1 "420811e92bcf7155164f1d4ac2d5a9768376765e" => :mountain_lion
    sha1 "5374c93b860377dab5e9349957bf26085c73614e" => :lion
  end

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
