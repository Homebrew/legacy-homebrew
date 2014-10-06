require "formula"

class Ktoblzcheck < Formula
  homepage "http://ktoblzcheck.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.46.tar.gz"
  sha1 "a97b7365cc9c103cc83115604d7c0dcf74b6ea71"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make install"
  end
end
