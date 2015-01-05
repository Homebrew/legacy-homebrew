require "formula"

class DnscryptWrapper < Formula
  homepage "http://cofyc.github.io/dnscrypt-wrapper/"
  head "https://github.com/Cofyc/dnscrypt-wrapper.git"
  url "https://github.com/Cofyc/dnscrypt-wrapper/releases/download/v0.1.15/dnscrypt-wrapper-v0.1.15.tar.bz2"
  sha256 "d486f3f923c6809c830e9db39290b0f44b1683f63f8bd3aeaa6225c64af232c1"

  depends_on "autoconf" => :build

  depends_on "libsodium"
  depends_on "libevent"

  def install
    args = ["--prefix=#{prefix}"]

    system "make configure"
    system "./configure", *args
    system "make"
    system "make install"
  end
end
