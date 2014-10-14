require 'formula'

class Hoedown < Formula
  homepage 'https://github.com/hoedown/hoedown'
  url 'https://github.com/hoedown/hoedown/archive/2.0.0.tar.gz'
  sha1 '51cd3f80b4798fb305b66bbfce4cfa7da9f1b775'

  def install
    system 'make', 'hoedown'
    bin.install 'hoedown'
    prefix.install 'test'
  end

  test do
    system 'perl', "#{prefix}/test/MarkdownTest_1.0.3/MarkdownTest.pl",
                   "--script=#{bin}/hoedown",
                   "--testdir=#{prefix}/test/MarkdownTest_1.0.3/Tests",
                   '--tidy'
  end
end
