require 'formula'

class BpmTools < Formula
  homepage 'http://www.pogo.org.uk/~mark/bpm-tools/'
  url 'http://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-0.2.tar.gz'
  sha1 '4c1d23a12b8d6cfbe23a5d2e6f232af4419b62c4'

  head 'http://www.pogo.org.uk/~mark/bpm-tools.git'

  option 'with-bpm-graph', 'Install plot generation script'
  option 'with-bpm-tag', 'Install audio file tagging script'

  depends_on 'gnuplot' if build.with? 'bpm-graph'
  depends_on 'sox' if build.with? 'bpm-tag'
  depends_on 'id3v2' if build.with? 'bpm-tag'
  depends_on 'flac' if build.with? 'bpm-tag'
  depends_on 'vorbis-tools' if build.with? 'bpm-tag'

  def install
    system "make"
    bin.install 'bpm'
    bin.install 'bpm-graph' if build.with? 'bpm-graph'
    bin.install 'bpm-tag' if build.with? 'bpm-tag'
  end
end
