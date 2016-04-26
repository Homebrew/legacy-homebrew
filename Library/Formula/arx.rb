require "language/haskell"

class Arx < Formula
  include Language::Haskell::Cabal

  desc "Bundles files and programs for easy transfer and repeatable execution"
  homepage "https://github.com/solidsnack/arx"
  url "https://github.com/solidsnack/arx/archive/0.2.2.tar.gz"
  sha256 "47e7a61a009d43c40ac0ce9c71917b0f967ef880c99d4602c7314b51c270fd0f"

  bottle do
    sha256 "3c68700a3ddfaed0ce393599f7709066641a33fba11b718c2b50e12496bc2131" => :el_capitan
    sha256 "0720dc2fe2b961a38f5c564a47469b941da92c619ef53f9c749cff628f628b93" => :yosemite
    sha256 "c46582bde1998cd229a5e5361b32eb194386008ff38944eaf663fbe4c53a146d" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"

      system "make"

      tag = `./bin/dist tag`.chomp
      bin.install "tmp/dist/arx-#{tag}/arx" => "arx"
    end
  end

  test do
    testscript = (testpath/"testing.sh")

    testscript.write shell_output("#{bin}/arx tmpx // echo 'testing'")
    testscript.chmod 0555

    assert_match /testing/, shell_output("./testing.sh")
  end
end
