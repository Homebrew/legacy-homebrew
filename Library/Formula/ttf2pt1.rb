require "formula"

class Ttf2pt1 < Formula
  homepage "http://ttf2pt1.sourceforge.net/"
  url "https://downloads.sourceforge.net/ttf2pt1/ttf2pt1-3.4.4.tgz"
  sha1 "936771b11a740c16a8e0adb737b54b22cca18cb2"

  def install
    system "make", "all", "INSTDIR=#{prefix}"
    bin.install "ttf2pt1"
    man1.install "ttf2pt1.1"
  end
end
