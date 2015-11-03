class NodenvPackageRehash < Formula
  desc "Automatically runs `nodenv rehash`"
  homepage "https://github.com/jasonkarns/nodenv-package-rehash"
  url "https://github.com/jasonkarns/nodenv-package-rehash/archive/v1.0.2.tar.gz"
  sha256 "7811b5fc85e472c93fe7f83f72a7a34c82f31d2fee671ab6e6ba8b44ee2071b0"
  head "https://github.com/jasonkarns/nodenv-package-rehash.git"

  depends_on "nodenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match /^package-hooks$/, shell_output("nodenv commands")
  end
end
