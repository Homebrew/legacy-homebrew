require "formula"

class Atpdec < Formula
  homepage "http://atpdec.sourceforge.net"
  url "https://downloads.sourceforge.net/project/atpdec/atpdec%20sources/1.7/atpdec-1.7.tar.gz"
  sha1 "161f357cd9f521a3a24d316f88a823453510a196"

  depends_on "libsndfile"
  depends_on "libpng"

  def install
    system "make"
    bin.install "atpdec"
  end

  test do
    system "atpdec"
  end
end
