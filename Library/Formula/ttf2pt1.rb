class Ttf2pt1 < Formula
  desc "True Type Font to Postscript Type 1 converter"
  homepage "http://ttf2pt1.sourceforge.net/"
  url "https://downloads.sourceforge.net/ttf2pt1/ttf2pt1-3.4.4.tgz"
  sha256 "ae926288be910073883b5c8a3b8fc168fde52b91199fdf13e92d72328945e1d0"

  def install
    system "make", "all", "INSTDIR=#{prefix}"
    bin.install "ttf2pt1"
    man1.install "ttf2pt1.1"
  end
end
