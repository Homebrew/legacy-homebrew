require "formula"

class Sfnt2woff < Formula
  homepage "http://people.mozilla.org/~jkew/woff/"
  url "http://people.mozilla.org/~jkew/woff/woff-code-latest.zip"
  sha1 "59879f1bdeeafce7fc9d4b51406e80d7a4cd0293"

  def install
    system "make"
    bin.install "sfnt2woff"
  end

  test do
      system bin/'sfnt2woff', '-h'
  end
end
