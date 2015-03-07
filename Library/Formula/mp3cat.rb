class Mp3cat < Formula
  homepage "http://tomclegg.net/mp3cat"
  url "http://tomclegg.net/software/mp3cat-0.4.tar.gz"
  sha1 "442d2b2b546fec4535c2aa892a8fc61db21eb917"

  bottle do
    cellar :any
    sha1 "ad6a863bffdc425ef897b1dc77062eeb8ee41f4a" => :yosemite
    sha1 "8cf1ca338feb3c3520c84013326bc86c0d48f4d7" => :mavericks
    sha1 "cc89db74d0e7ddfbc38beeb9bc53d3ade5a7e8dc" => :mountain_lion
  end

  def install
    system "make"
    bin.install %w(mp3cat mp3log mp3log-conf mp3dirclean mp3http mp3stream-conf)
  end

  test do
    pipe_output("#{bin}/mp3cat -v --noclean - -", test_fixtures("test.mp3"))
  end
end
