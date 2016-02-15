require "language/haskell"

class Elm < Formula
  include Language::Haskell::Cabal

  desc "Functional programming language for building browser-based GUIs"
  homepage "http://elm-lang.org"

  stable do
    url "https://github.com/elm-lang/elm-compiler/archive/0.16.tar.gz"
    sha256 "ea4ff37ec6a1bfb8876e7a9b2aa0755df9ac92f5e5c8bfcc611b1886fb06bb13"

    resource "elm-package" do
      url "https://github.com/elm-lang/elm-package/archive/0.16.tar.gz"
      sha256 "1cac7d27415a4d36d7b1c7260953e0c7b006e7cbb24d5bdb3b0d440d375a8bf5"
    end

    resource "elm-make" do
      url "https://github.com/elm-lang/elm-make/archive/0.16.tar.gz"
      sha256 "ed2eb38ee3d41307751b9df4fd464987c7cdd96413a907b800923af8a25a8c15"
    end

    resource "elm-repl" do
      url "https://github.com/elm-lang/elm-repl/archive/0.16.tar.gz"
      sha256 "ea89a6cccd546e26c6af12bd35b886bfa666888323596c60168013acf67fe2e4"
    end

    resource "elm-reactor" do
      url "https://github.com/elm-lang/elm-reactor/archive/0.16.tar.gz"
      sha256 "fd105180b92364c3ba8df58bfa88306adb8a21074786267ab1eaa634777ded7f"
    end
  end

  bottle do
    sha256 "af4973a6501741e69289163297cb1f3f20f1837dbca7c38ca8fc7cf8116a8460" => :el_capitan
    sha256 "8e768f845671c3e83197abd99cb4e07bea0c2cdaa293023fe27fbb7b5f90cb19" => :yosemite
    sha256 "631587361e3e35dbd6677de2c6b580bd88b5ed04835c8b6ca763649d98579da7" => :mavericks
  end

  head do
    url "https://github.com/elm-lang/elm-compiler.git"

    resource "elm-package" do
      url "https://github.com/elm-lang/elm-package.git"
    end

    resource "elm-make" do
      url "https://github.com/elm-lang/elm-make.git"
    end

    resource "elm-repl" do
      url "https://github.com/elm-lang/elm-repl.git"
    end

    resource "elm-reactor" do
      url "https://github.com/elm-lang/elm-reactor.git"
    end
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    # elm-compiler needs to be staged in a subdirectory for the build process to succeed
    (buildpath/"elm-compiler").install Dir["*"]

    extras_no_reactor = ["elm-package", "elm-make", "elm-repl"]
    extras = extras_no_reactor + ["elm-reactor"]
    extras.each do |extra|
      resource(extra).stage buildpath/extra
    end

    cabal_sandbox do
      cabal_sandbox_add_source "elm-compiler", *extras
      cabal_install "--only-dependencies", "elm-compiler", *extras
      cabal_install "--prefix=#{prefix}", "elm-compiler", *extras_no_reactor

      # elm-reactor needs to be installed last because of a post-build dependency on elm-make
      ENV.prepend_path "PATH", bin

      cabal_install "--prefix=#{prefix}", "elm-reactor"
    end
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<-EOS.undent
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm", "package", "install", "evancz/elm-html", "--yes"

    out_path = testpath/"index.html"
    system bin/"elm", "make", src_path, "--output=#{out_path}"
    assert File.exist?(out_path)
  end
end
