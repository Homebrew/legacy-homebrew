class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/v2.6.tar.gz"
  sha256 "286b3285f096a5d249de1507eee88b14848514696bc5bbc4faceffa46b563ebd"

  depends_on "openssl"

  def install
    bin.install "testssl.sh"
  end
end
