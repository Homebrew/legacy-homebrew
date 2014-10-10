require "formula"

class Cliclick < Formula
  homepage "http://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/3.0.2.tar.gz"
  sha1 "7e6dbdf772adf2e36c66dee51bd077a89fe574fa"

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
