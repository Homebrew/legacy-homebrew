require 'formula'

class Daemon < Formula
  homepage 'http://libslack.org/daemon/'
  url 'http://libslack.org/daemon/download/daemon-0.6.4.tar.gz'
  sha1 'fa6298f05f868d54660a7ed70c05fb7a0963a24b'

  def install
    system "./config"
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def test
    system "#{bin}/daemon", "--version"
  end
end
