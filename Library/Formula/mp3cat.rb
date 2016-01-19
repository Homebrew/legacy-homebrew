class Mp3cat < Formula
  desc "Reads and writes mp3 files"
  homepage "http://tomclegg.net/mp3cat"
  url "http://tomclegg.net/software/mp3cat-0.4.tar.gz"
  sha256 "fd2b0d58018f5117bd1e22298c899bef5e6af61a0c540186d16d2bf516d6849a"

  bottle do
    cellar :any
    sha256 "a70d1a1a379c4813f57c32284f13348e36302a61d0c933c2a4fb19342c43be1f" => :yosemite
    sha256 "43053bea923c17bd7a31532cdcaedfcb3681a04aa1b0b66e33defc41c7e00629" => :mavericks
    sha256 "bffd0a1ea0cb5ce1eb39c4147686702f060dd25e949385009946835be9826b8d" => :mountain_lion
  end

  def install
    system "make"
    bin.install %w[mp3cat mp3log mp3log-conf mp3dirclean mp3http mp3stream-conf]
  end

  test do
    pipe_output("#{bin}/mp3cat -v --noclean - -", test_fixtures("test.mp3"))
  end
end
