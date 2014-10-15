require "formula"

class Cliclick < Formula
  homepage "http://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/3.0.2.tar.gz"
  sha1 "7e6dbdf772adf2e36c66dee51bd077a89fe574fa"

  bottle do
    cellar :any
    sha1 "a56d6d6c95c5cb7f6641d4f6484e944542aaa6e5" => :mavericks
    sha1 "b8b97526eb4ff4c38f025a418214e0a166b9758a" => :mountain_lion
    sha1 "feca3a136c0ff6a464ddfec9e7d4b73f93739a45" => :lion
  end

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
