require 'formula'

class Daemon < Formula
  url 'http://libslack.org/daemon/download/daemon-0.6.4.tar.gz'
  homepage 'http://libslack.org/daemon/'
  md5 '6cd0a28630a29ac279bc501f39baec66'

  def install
    system "./config"
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def test
    system "#{bin}/daemon", "--version"
  end
end
