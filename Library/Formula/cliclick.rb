require 'formula'

class Cliclick < Formula
  homepage 'http://www.bluem.net/jump/cliclick/'
  url 'https://github.com/BlueM/cliclick/archive/2.3.tar.gz'
  sha1 '95e4e21872e02bbf4705b65eabc6681c1e86aedd'

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system "cliclick p:OK"
  end
end
