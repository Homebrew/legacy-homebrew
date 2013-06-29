require 'formula'

class Pipemeter < Formula
  homepage 'https://launchpad.net/pipemeter'
  url 'https://launchpad.net/pipemeter/trunk/1.1.3/+download/pipemeter-1.1.3.tar.gz'
  sha1 '8fe224b0cf77e9f3932f46fed0af5acc6547cd0c'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    bin.install "pipemeter"
    man1.install "pipemeter.1"
  end
end
