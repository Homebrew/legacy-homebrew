class Arx < Formula
  desc "Bundles files and programs for easy transfer and repeatable execution"
  homepage "https://github.com/solidsnack/arx"
  url "https://github.com/solidsnack/arx/archive/0.2.1.tar.gz"
  sha256 "c3e91e4b9f72353061b0a104ee752da88770d695ef6329eca0f1049a56e9c110"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    system "cabal", "sandbox", "init"
    system "cabal", "update"
    system "cabal", "install", "--only-dependencies"
    system "make"

    tag = `./bin/dist tag`.chomp
    bin.install "tmp/dist/arx-#{tag}/arx" => "arx"
  end

  test do
    testscript = (testpath/"testing.sh")

    testscript.write shell_output("#{bin}/arx tmpx // echo 'testing'")
    testscript.chmod 0555

    assert_match /testing/, shell_output("./testing.sh")
  end
end
