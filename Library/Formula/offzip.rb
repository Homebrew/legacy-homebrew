class Offzip < Formula
  version "0.3.6a"
  homepage "http://aluigi.altervista.org/mytoolz.htm#offzip"
  url "http://aluigi.altervista.org/mytoolz/offzip.zip"
  sha256 "71d578d4bcfad52857ef7d2db0b16935ad88aaef493c9b4367d310069efd892b"

  def install
    system ENV.cc, "offzip.c", "-o", "offzip", "-lz"
    bin.install "offzip"
  end
end
