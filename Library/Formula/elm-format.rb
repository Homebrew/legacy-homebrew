require "language/haskell"

class ElmFormat < Formula
  include Language::Haskell::Cabal
  desc "formats Elm source code based on the official Elm Style Guide"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format/archive/0.2.0-alpha.tar.gz"
  version "3"
  sha256 "b965ba2a1633524da7fd2bc16eb07b2855c9f9b929024450dbc4256b3a127997"
  head "https://github.com/avh4/elm-format.git"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    (buildpath/"elm-format").install Dir["*"]

    cabal_sandbox do
      cabal_sandbox_add_source "elm-format"
      cabal_install "--only-dependencies", "elm-format"
      cabal_install "--prefix=#{prefix}", "elm-format"
    end
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<-EOS.undent
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm-format", testpath/"Hello.elm", "--yes"
  end
end
