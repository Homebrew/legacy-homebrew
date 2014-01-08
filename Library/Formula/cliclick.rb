require 'formula'

class Cliclick < Formula
  homepage 'http://www.bluem.net/jump/cliclick/'
  url 'https://github.com/BlueM/cliclick/archive/2.3.1.tar.gz'
  sha1 '84ae09fb8e40ffada80d81713dcfae05a80b4c7e'

  depends_on :xcode

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
