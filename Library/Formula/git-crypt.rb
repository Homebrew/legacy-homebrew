class GitCrypt < Formula
  desc "Enable transparent encryption/decryption of files in a git repo"
  homepage "https://www.agwa.name/projects/git-crypt/"
  url "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.5.0.tar.gz"
  sha256 "0a8f92c0a0a125bf768d0c054d947ca4e4b8d6556454b0e7e87fb907ee17cf06"

  bottle do
    cellar :any
    sha256 "ce33f2d01af41259b6ea9be1e849000bdd08413b1f109268ea65709644d455eb" => :yosemite
    sha256 "2cedd573983fe7ec7387e76f9ffd0ba351e71e19e3382f7365209d1aad0f7e3f" => :mavericks
    sha256 "1bba33a973b90d39140a64193bcdab63b34c3b4f379850ee41ee155325173f4f" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "make"
    bin.install "git-crypt"
  end

  test do
    system "#{bin}/git-crypt", "keygen", "keyfile"
  end
end
