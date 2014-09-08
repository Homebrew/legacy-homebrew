require "formula"

class Hevea < Formula
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/distri/hevea-2.16.tar.gz"
  sha1 "729438f4c37240df7b20053dec18e9ee17d19d46"

  bottle do
    cellar :any
    sha1 "e2913f505d600a5a44ea31ee28bd6f80574bbcf0" => :mavericks
    sha1 "c48beb71f6e9489cdb105dd53f066c09dd26a3ad" => :mountain_lion
    sha1 "421f60fc322551f1e80a7215475f57c43319165b" => :lion
  end

  depends_on "objective-caml"
  depends_on "ghostscript" => :optional

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
