class Espeak < Formula
  desc "Text to speech, software speech synthesizer"
  homepage "http://espeak.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/espeak/espeak/espeak-1.48/espeak-1.48.04-source.zip"
  sha256 "bf9a17673adffcc28ff7ea18764f06136547e97bbd9edf2ec612f09b207f0659"

  bottle do
    sha256 "f174e6d33f96be4924ecb4b33c764cffdbc2444ea87a626f150dd80a3d2f6765" => :el_capitan
    sha256 "1bb63666e796b5454d53df1004365da2f53f428a6f953fa20fd1bacf909ca61a" => :mavericks
    sha256 "0ed56b0461f6c4c9e859c88d438cdcb8abfad974becb192bb758b7ba6b8fb0b4" => :mountain_lion
    sha256 "2a029aca1a91cf4b2a4cb652f9a3ce6c7a3c9590d5af4aba7038b710ce6d6441" => :lion
  end

  depends_on "portaudio"

  def install
    share.install "espeak-data"
    cd "src" do
      rm "portaudio.h"
      system "make", "speak", "DATADIR=#{share}/espeak-data", "PREFIX=#{prefix}"
      bin.install "speak" => "espeak"
    end
  end

  test do
    system "#{bin}/espeak", "This is a test for Espeak.", "-w", "out.wav"
  end
end
