require "formula"

class Espeak < Formula
  homepage "http://espeak.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/espeak/espeak/espeak-1.48/espeak-1.48.04-source.zip"
  sha1 "b22c0361885d05e61d98ecedca0a4926ea2fb2ad"

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
