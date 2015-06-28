class Sfnt2woff < Formula
  desc "Convert TTF and OTF fonts to WOFF format."
  homepage "https://people.mozilla.org/~jkew/woff/"
  url "https://people.mozilla.org/~jkew/woff/woff-code-latest.zip"
  version "1.0"
  sha256 "7713630d2f43320a1d92e2dbb014ca3201caab1dd4c0ab92816016824c680d96"

  def install
    system "make"
    bin.install "sfnt2woff"
    bin.install "woff2sfnt"
  end

  test do
    system "#{bin}/sfnt2woff", "-help"
    system "#{bin}/woff2sfnt", "-help"
  end
end
