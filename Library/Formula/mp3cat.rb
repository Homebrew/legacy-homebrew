class Mp3cat < Formula
  homepage "http://tomclegg.net/mp3cat"
  url "http://tomclegg.net/software/mp3cat-0.4.tar.gz"
  sha1 "442d2b2b546fec4535c2aa892a8fc61db21eb917"

  def install
    system "make"
    bin.install %w(mp3cat mp3log mp3log-conf mp3dirclean mp3http mp3stream-conf)
  end

  test do
    pipe_output("#{bin}/mp3cat -v --noclean - -", test_fixtures("test.mp3"))
  end
end
