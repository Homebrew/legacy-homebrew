require "formula"

class Libstrophe < Formula
  homepage "http://strophe.im/libstrophe"
  url "https://github.com/strophe/libstrophe.git"
  #sha1 ""
  version "current"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "expat"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
