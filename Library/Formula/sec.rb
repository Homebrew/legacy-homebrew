require "formula"

class Sec < Formula
  homepage "http://simple-evcorr.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/simple-evcorr/sec/2.7.6/sec-2.7.6.tar.gz"
  sha1 "171fe152563832497f2647b6d1b9aa4b8047ba4e"

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
