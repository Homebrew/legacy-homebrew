require "formula"

class Darkhttpd < Formula
  homepage "http://unix4lyfe.org/darkhttpd/"
  url "http://unix4lyfe.org/darkhttpd/darkhttpd-1.10.tar.bz2"
  sha1 "95443b7374817137e58e28ebfff47d322cfbad25"

  def install
    system "make"
    bin.install "darkhttpd"
  end

  test do
    system "#{bin}/darkhttpd", "--help"
  end
end
