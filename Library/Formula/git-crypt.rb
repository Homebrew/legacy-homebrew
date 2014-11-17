require 'formula'

class GitCrypt < Formula
  homepage 'https://www.agwa.name/projects/git-crypt/'
  url 'https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.4.tar.gz'
  sha1 '18cffadc905d69e221e6f2d4ec92b013413596f3'

  depends_on "openssl"

  def install
    system "make"
    bin.install "git-crypt"
  end

  test do
    system "#{bin}/git-crypt", "keygen", "keyfile"
  end
end
