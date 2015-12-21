class Jailkit < Formula
  desc "Utilities to create limited user accounts in a chroot jail"
  homepage "http://olivier.sessink.nl/jailkit/"
  url "http://olivier.sessink.nl/jailkit/jailkit-2.19.tar.bz2"
  sha256 "bebbf6317a5a15057194dd2cf6201821c48c022dbc64c12756eb13b61eff9bf9"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
