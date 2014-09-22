require "formula"

class Cliclick < Formula
  homepage "http://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/3.0.1.tar.gz"
  sha1 "be5e9069b1706da0b49f6a127a1912bb67346213"

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
