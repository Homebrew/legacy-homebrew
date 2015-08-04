class Mp3cat < Formula
  desc "Reads and writes mp3 files"
  homepage "http://tomclegg.net/mp3cat"
  url "http://tomclegg.net/software/mp3cat-0.4.tar.gz"
  sha256 "fd2b0d58018f5117bd1e22298c899bef5e6af61a0c540186d16d2bf516d6849a"

  bottle do
    cellar :any
    sha1 "ad6a863bffdc425ef897b1dc77062eeb8ee41f4a" => :yosemite
    sha1 "8cf1ca338feb3c3520c84013326bc86c0d48f4d7" => :mavericks
    sha1 "cc89db74d0e7ddfbc38beeb9bc53d3ade5a7e8dc" => :mountain_lion
  end

  def install
    system "make"
    bin.install %w[mp3cat mp3log mp3log-conf mp3dirclean mp3http mp3stream-conf]
  end

  test do
    pipe_output("#{bin}/mp3cat -v --noclean - -", test_fixtures("test.mp3"))
  end
end
