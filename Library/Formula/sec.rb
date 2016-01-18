class Sec < Formula
  desc "Event correlation tool for event processing of various kinds"
  homepage "http://simple-evcorr.sourceforge.net/"
  url "https://github.com/simple-evcorr/sec/releases/download/2.7.8/sec-2.7.8.tar.gz"
  mirror "https://downloads.sourceforge.net/project/simple-evcorr/sec/2.7.8/sec-2.7.8.tar.gz"
  sha256 "4771d0c7b45937cce263ca9728cf243f82e44b2ef153da0e1a478c6b1e46537f"

  bottle :unneeded

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
