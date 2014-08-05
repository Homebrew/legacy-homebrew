require "formula"

class Ngrok < Formula
  homepage "https://ngrok.com"
  head "https://github.com/inconshreveable/ngrok.git", :branch => "master"
  url "https://github.com/inconshreveable/ngrok/archive/1.7.tar.gz"
  sha1 "4a6baf98a23193c21d7732c6573f53dbbede5033"

  bottle do
  end

  depends_on "go" => :build
  depends_on :hg => :build

  def install
    ENV.j1
    system "make", "release-client"
    bin.install "bin/ngrok"
  end

  test do
    system "#{bin}/ngrok", "version"
  end
end
