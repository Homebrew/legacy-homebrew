require "formula"

class Scamper < Formula
  homepage "http://www.caida.org/tools/measurement/scamper/"
  url "http://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20140530.tar.gz"
  sha1 "b04e63ef6853cc75857fb2b51f1e9b022622e912"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
