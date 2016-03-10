require "language/haskell"

class Arx < Formula
  include Language::Haskell::Cabal

  desc "Bundles files and programs for easy transfer and repeatable execution"
  homepage "https://github.com/solidsnack/arx"
  url "https://github.com/solidsnack/arx/archive/0.2.2.tar.gz"
  sha256 "47e7a61a009d43c40ac0ce9c71917b0f967ef880c99d4602c7314b51c270fd0f"

  bottle do
    sha256 "5f872b7d40a3c6dd1ea8fd3ee24296e7758c4693d62a2dbc07612688ab55c4a5" => :el_capitan
    sha256 "2711faa378132775c5e152d6649a31d6a758006f1fb4fdd60d968466c7a3afee" => :yosemite
    sha256 "acb50b98723382ab596b4e83aeb1ad3a8a3ad69648244bd3178425bc3a2ecebb" => :mavericks
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
