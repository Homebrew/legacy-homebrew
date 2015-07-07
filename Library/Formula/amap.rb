require "formula"

class Amap < Formula
  desc "Perform application protocol detection"
  homepage "https://www.thc.org/thc-amap/"
  url "https://www.thc.org/releases/amap-5.4.tar.gz"
  sha1 "79056f29a3b9e0a21062116aec3e966b1a46d7d3"
  revision 1

  bottle do
    cellar :any
    sha1 "3e5f595cd8e8427dd9e644331538be8c39997500" => :yosemite
    sha1 "8e3eaec3b621aa8cda4f9fae3a80f66bfb53cb47" => :mavericks
    sha1 "6b625caf2d80f33a9175d1e6370ebff677237c29" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    # --prefix doesn't work as we want it to so install manually
    bin.install "amap", "amap6", "amapcrap"
    man1.install "amap.1"
  end
end
