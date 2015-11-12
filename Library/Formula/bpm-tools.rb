class BpmTools < Formula
  desc "Detect tempo of audio files using beats-per-minute (BPM)"
  homepage "http://www.pogo.org.uk/~mark/bpm-tools/"
  url "http://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-0.3.tar.gz"
  sha256 "37efe81ef594e9df17763e0a6fc29617769df12dfab6358f5e910d88f4723b94"
  head "http://www.pogo.org.uk/~mark/bpm-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0348970a3f89990ed97a15e10dff48f07b853d01d32a640a98e6c835d78f09d7" => :el_capitan
    sha256 "d6bcb8fe9273b0640c2272bd9f4255797eec40a7369362600a62473c3cfd1c27" => :yosemite
    sha256 "702aa6266adb11c4aada4711f32a45e93cd2bff67e62c9d420ecd748d7d80ead" => :mavericks
  end

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
