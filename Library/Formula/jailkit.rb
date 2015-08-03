class Jailkit < Formula
  desc "Utilities to create limited user accounts in a chroot jail"
  homepage "http://olivier.sessink.nl/jailkit/"
  url "http://olivier.sessink.nl/jailkit/jailkit-2.17.tar.bz2"
  sha256 "5db1d130b144c49136450369da55ab9d8c4861da3351bb4e11ab1e0921764cba"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
