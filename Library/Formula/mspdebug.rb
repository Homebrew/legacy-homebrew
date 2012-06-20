require 'formula'

class Mspdebug < Formula
  homepage 'http://mspdebug.sourceforge.net'

  url 'http://downloads.sourceforge.net/project/mspdebug/mspdebug-0.19.tar.gz'
  sha1 '329ad2c4cd9496dc7d24fccd59895c8d68e2bc9a'

  depends_on 'libusb-compat'

  def install
    system "make install PREFIX=#{prefix}"
  end

  def test
    system "mspdebug --version"
  end
end
