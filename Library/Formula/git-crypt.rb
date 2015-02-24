require 'formula'

class GitCrypt < Formula
  homepage 'https://www.agwa.name/projects/git-crypt/'
  url "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.4.2.tar.gz"
  sha1 "c084d73d285ed2c7b9840d4d527cb51ecc7a687b"

  bottle do
    cellar :any
    sha1 "f06679b30da507716f4db5fe06c8251e3702d5a7" => :yosemite
    sha1 "bbe990ecebdefe37de0a46e4ad9f869e39a8076e" => :mavericks
    sha1 "325e8630865b13f9d319d33777053921838d16e7" => :mountain_lion
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
