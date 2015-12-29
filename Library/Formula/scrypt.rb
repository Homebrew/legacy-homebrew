class Scrypt < Formula
  desc "Encrypt and decrypt files using memory-hard password function"
  homepage "https://www.tarsnap.com/scrypt.html"
  url "https://www.tarsnap.com/scrypt/scrypt-1.2.0.tgz"
  sha256 "1754bc89405277c8ac14220377a4c240ddc34b1ce70882aa92cd01bfdc8569d4"

  bottle do
    cellar :any
    revision 1
    sha256 "a81147625da927a61035f18d320a56d4b7e0055cc3ff0640dde0e6f2c0cada9d" => :el_capitan
    sha256 "ad6fee3523c53b2f323b896d60de404c1358459ceffdf8a9014967b045863051" => :yosemite
    sha256 "fc7272e275fd43e3c5a63bf00294564823a944639ab60ed10aaae40cf2a67f8a" => :mavericks
  end

  head do
    url "https://github.com/Tarsnap/scrypt.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "openssl"

  def install
    system "autoreconf", "-fvi" if build.head?
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
