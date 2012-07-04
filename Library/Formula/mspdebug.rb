require 'formula'

class Mspdebug < Formula
  homepage 'http://mspdebug.sourceforge.net/'
  url 'http://sourceforge.net/projects/mspdebug/files/mspdebug-0.19.tar.gz'
  sha1 '329ad2c4cd9496dc7d24fccd59895c8d68e2bc9a'

  depends_on 'libusb'
  def install
    system "env PREFIX=#{prefix} make"
    system "make install"
  end

  def test
    system "mspdebug --help"
  end
end
