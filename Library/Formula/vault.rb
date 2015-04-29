class Vault < Formula
  homepage "https://vaultproject.io/"
  url "https://dl.bintray.com/mitchellh/vault/vault_0.1.0_darwin_amd64.zip"
  version "0.1.0"
  sha256 "e0a1a1ace4c9577408800825b374c0239c04ebc9ab6ed18c924dc8f0393b9fd5"

  def install
    bin.install "vault"
  end

  test do
    system bin/"vault", "--version"
  end
end
