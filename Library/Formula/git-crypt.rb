require 'formula'

class GitCrypt < Formula
  homepage 'https://www.agwa.name/projects/git-crypt/'
  url "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.4.2.tar.gz"
  sha1 "c084d73d285ed2c7b9840d4d527cb51ecc7a687b"

  depends_on "openssl"

  def install
    system "make"
    bin.install "git-crypt"
  end

  test do
    # Note; `git-crypt keygen` planned for deprecation
    system "#{bin}/git-crypt", "keygen", "keyfile"
  end
end
