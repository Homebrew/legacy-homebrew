require "language/haskell"

class Waiter < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/davejachimiak/waiter"
  url "https://github.com/davejachimiak/waiter/archive/0.1.0.0.tar.gz"
  sha256 "b0d4e10fcf9c9bc2ef7376bd65d3d8a73e16b7450e60328d9f93a72de1b2ec08"

  depends_on "cabal-install" => :build
  depends_on "ghc"

  def install
    install_cabal_package
  end

  test do
    waiter = bin/"waiter"
    system waiter, "--help"
  end
end
