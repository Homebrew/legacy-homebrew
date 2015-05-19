require 'formula'

class BpmTools < Formula
  desc "Detect tempo of audio files using beats-per-minute (BPM)"
  homepage 'http://www.pogo.org.uk/~mark/bpm-tools/'
  head 'http://www.pogo.org.uk/~mark/bpm-tools.git'
  url 'http://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-0.3.tar.gz'
  sha1 '33da8c03757c91834bb0a695d7ee0f3e8faede65'

  option 'with-bpm-graph', 'Install plot generation script'
  option 'with-bpm-tag', 'Install audio file tagging script'

  depends_on 'gnuplot' if build.with? 'bpm-graph'

  if build.with? "bpm-tag"
    depends_on 'sox'
    depends_on 'id3v2'
    depends_on 'flac'
    depends_on 'vorbis-tools'
  end

  def install
    system "make"
    bin.install 'bpm'
    bin.install 'bpm-graph' if build.with? 'bpm-graph'
    bin.install 'bpm-tag' if build.with? 'bpm-tag'
  end
end
