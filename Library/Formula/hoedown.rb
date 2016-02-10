class Hoedown < Formula
  desc "Secure Markdown processing (a revived fork of Sundown)"
  homepage "https://github.com/hoedown/hoedown"
  url "https://github.com/hoedown/hoedown/archive/3.0.7.tar.gz"
  sha256 "01b6021b1ec329b70687c0d240b12edcaf09c4aa28423ddf344d2bd9056ba920"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f9b338a9b865b617a3ce0891619023255726826f164de12945e999371678f9c" => :el_capitan
    sha256 "89643d3ec6ac8c9390416ef481011b02a6758378c9723a325b74ccabd1935978" => :yosemite
    sha256 "815403f7249c0e920281d133153fc65afc611ad8de6e160c9467d2a0690cd2f3" => :mavericks
  end

  def install
    system "make", "hoedown"
    bin.install "hoedown"
    prefix.install "test"
  end

  test do
    system "perl", "#{prefix}/test/MarkdownTest_1.0.3/MarkdownTest.pl",
                   "--script=#{bin}/hoedown",
                   "--testdir=#{prefix}/test/MarkdownTest_1.0.3/Tests",
                   "--tidy"
  end
end
