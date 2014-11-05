require "formula"

class KindleGen < Formula
  homepage "http://www.amazon.com/gp/feature.html?docId=1000765211"
  url "http://kindlegen.s3.amazonaws.com/KindleGen_Mac_i386_v2_9.zip"
  sha1 "94e959d10d51f4fe938b8ddab11bcc2c4dd26b39"
  version "2.9"

  def install
		bin.install "kindlegen"
  end

  def caveats; <<-EOS.undent
    Usage:
      kindlegen -c2 -dont_append_source ebook.epub
    EOS
  end

  test do
    system "kindlegen"
  end
end
