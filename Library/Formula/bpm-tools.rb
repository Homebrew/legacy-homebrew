class BpmTools < Formula
  desc "Detect tempo of audio files using beats-per-minute (BPM)"
  homepage "http://www.pogo.org.uk/~mark/bpm-tools/"
  head "http://www.pogo.org.uk/~mark/bpm-tools.git"
  url "http://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-0.3.tar.gz"
  sha256 "37efe81ef594e9df17763e0a6fc29617769df12dfab6358f5e910d88f4723b94"

  option "with-bpm-graph", "Install plot generation script"
  option "with-bpm-tag", "Install audio file tagging script"

  depends_on "gnuplot" if build.with? "bpm-graph"

  if build.with? "bpm-tag"
    depends_on "sox"
    depends_on "id3v2"
    depends_on "flac"
    depends_on "vorbis-tools"
  end

  def install
    system "make"
    bin.install "bpm"
    bin.install "bpm-graph" if build.with? "bpm-graph"
    bin.install "bpm-tag" if build.with? "bpm-tag"
  end
end
