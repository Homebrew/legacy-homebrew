require "formula"

class Darkhttpd < Formula
  homepage "http://unix4lyfe.org/darkhttpd/"
  url "http://unix4lyfe.org/darkhttpd/darkhttpd-1.9.tar.bz2"
  sha1 "0d95d5bc4054ea3719b3a85c4ad6e5a839b3217e"

  def install
    system "make"
    bin.install "darkhttpd"
  end
end
