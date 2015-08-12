class Hoedown < Formula
  desc "Secure Markdown processing (a revived fork of Sundown)"
  homepage "https://github.com/hoedown/hoedown"
  url "https://github.com/hoedown/hoedown/archive/3.0.7.tar.gz"
  sha256 "01b6021b1ec329b70687c0d240b12edcaf09c4aa28423ddf344d2bd9056ba920"

  bottle do
    cellar :any_skip_relocation
    sha256 "7076f6f7c091919a3619a5a5655270d79dab42fdb6d7dfdc3f1324318ca4ec6d" => :el_capitan
    sha256 "fc37aa79feca395a49b3e15348d8156721ba1713dfb740622c57a696d1ec5e58" => :yosemite
    sha256 "9940929bd2ede20f973f29fdac888c6b664188bf29e9a1f7c8eba0eeb42e6206" => :mavericks
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
