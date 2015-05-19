require "formula"

class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "http://www.caida.org/tools/measurement/scamper/"
  url "http://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20141101.tar.gz"
  sha1 "564c2cbb60ad0d5ac27cef81e7901ca567b4473c"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
