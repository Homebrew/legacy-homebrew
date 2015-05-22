class Elm < Formula
  homepage "http://elm-lang.org"
  url "https://github.com/kevva/elm-bin/raw/v1.4.1/vendor/osx/elm-platform-osx.tar.gz"
  sha256 "ec94047ca573e66aed5e6ac21ab8656b203bf9e3262f0819dfb35780c3700623"
  version "0.15"

  def install
    [
      "elm",
      "elm-doc",
      "elm-make",
      "elm-package",
      "elm-reactor",
      "elm-repl"
    ].each do |binaryFile|
      bin.install binaryFile
    end
  end

  test do
    system "elm", "make", "--help"
  end
end
