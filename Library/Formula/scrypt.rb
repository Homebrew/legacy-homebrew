class Scrypt < Formula
  desc "Encrypt and decrypt files using memory-hard password function"
  homepage "https://www.tarsnap.com/scrypt.html"
  url "https://www.tarsnap.com/scrypt/scrypt-1.2.0.tgz"
  sha256 "1754bc89405277c8ac14220377a4c240ddc34b1ce70882aa92cd01bfdc8569d4"

  bottle do
    cellar :any
    sha256 "2be3e6d53234791bcb7e22b5c7824425259238607ec94c20537a3e8d77865113" => :yosemite
    sha256 "fffd73cea8ac255b12dfc2ed1a5445f0053e5d8ec0d1f9da55e3a5c64b9f27fd" => :mavericks
    sha256 "451f8217e0d27b265b6aa7f9752488b7c4986d5dce77e394aeae35361e839bd7" => :mountain_lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.sh").write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/scrypt enc homebrew.txt homebrew.txt.enc
      expect -exact "Please enter passphrase: "
      send -- "Testing\n"
      expect -exact "\r
      Please confirm passphrase: "
      send -- "Testing\n"
      expect eof
    EOS
    chmod 0755, testpath/"test.sh"
    touch "homebrew.txt"

    system "./test.sh"
    assert File.exist?("homebrew.txt.enc")
  end
end
