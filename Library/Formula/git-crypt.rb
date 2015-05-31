class GitCrypt < Formula
  homepage 'https://www.agwa.name/projects/git-crypt/'
  url "https://www.agwa.name/projects/git-crypt/downloads/git-crypt-0.5.0.tar.gz"
  sha256 "0a8f92c0a0a125bf768d0c054d947ca4e4b8d6556454b0e7e87fb907ee17cf06"

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
