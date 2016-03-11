require "language/haskell"

class ElmReactor < Formula
  include Language::Haskell::Cabal

  desc "Interactive development tool for Elm programs"
  homepage "http://elm-lang.org"
  url "https://github.com/elm-lang/elm-reactor/archive/0.16.tar.gz"
  sha256 "fd105180b92364c3ba8df58bfa88306adb8a21074786267ab1eaa634777ded7f"
  head "https://github.com/elm-lang/elm-reactor.git"

  bottle do
    sha256 "af4973a6501741e69289163297cb1f3f20f1837dbca7c38ca8fc7cf8116a8460" => :el_capitan
    sha256 "8e768f845671c3e83197abd99cb4e07bea0c2cdaa293023fe27fbb7b5f90cb19" => :yosemite
    sha256 "631587361e3e35dbd6677de2c6b580bd88b5ed04835c8b6ca763649d98579da7" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  resource "elm-compiler" do
    url "https://github.com/elm-lang/elm-compiler/archive/0.16.tar.gz"
    sha256 "ea4ff37ec6a1bfb8876e7a9b2aa0755df9ac92f5e5c8bfcc611b1886fb06bb13"
  end

  resource "elm-package" do
    url "https://github.com/elm-lang/elm-package/archive/0.16.tar.gz"
    sha256 "1cac7d27415a4d36d7b1c7260953e0c7b006e7cbb24d5bdb3b0d440d375a8bf5"
  end

  resource "elm-make" do
    url "https://github.com/elm-lang/elm-make/archive/0.16.tar.gz"
    sha256 "ed2eb38ee3d41307751b9df4fd464987c7cdd96413a907b800923af8a25a8c15"
  end

  def install
    (buildpath/"elm-reactor").install Dir["*"]
    resources = %w[elm-compiler elm-package elm-make]
    resources.each do |r|
      resource(r).stage buildpath/r
    end

    cabal_sandbox do
      cabal_sandbox_add_source "elm-reactor", *resources
      cabal_install "--only-dependencies", *resources, "elm-reactor"
      cabal_install *resources
      ENV.deparallelize { cabal_install "--prefix=#{prefix}", "elm-reactor" }
    end
  end
end
