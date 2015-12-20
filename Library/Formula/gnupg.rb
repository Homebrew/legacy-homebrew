class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.20.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.20.tar.bz2"
  sha256 "04988b1030fa28ddf961ca8ff6f0f8984e0cddcb1eb02859d5d8fe0fe237edcc"

  bottle do
    sha256 "eba128a335d51a62017be92586669cacbf80ed88c77fe61ba2b85bce855ae6f1" => :el_capitan
    sha256 "a24328a0ca8abc2979328d95cc2a6ea1b6f10877dd62938ae00653047cf03537" => :yosemite
    sha256 "0532a2034dbb40798975ed7aa3c5b6e3985c6b03c51eb91f8e132e8f2341104c" => :mavericks
    sha256 "23beb78882a472faff36d237e028b34749da9315b81249beed8b4305bf1d393f" => :mountain_lion
  end

  depends_on "curl" if MacOS.version <= :mavericks

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-asm"
    system "make"
    system "make", "check"

    # we need to create these directories because the install target has the
    # dependency order wrong
    [bin, libexec/"gnupg"].each(&:mkpath)
    system "make", "install"
  end

  test do
    (testpath/"gen-key-script").write <<-EOS.undent
      Key-Type: RSA
      Key-Length: 4096
      Subkey-Type: RSA
      Subkey-Length: 4096
      Name-Real: Homebrew Test
      Name-Email: test@example.com
      Expire-Date: 0
    EOS
    system bin/"gpg", "--batch", "--gen-key", "gen-key-script"
    (testpath/"test.txt").write ("Hello World!")
    system bin/"gpg", "--armor", "--sign", "test.txt"
    system bin/"gpg", "--verify", "test.txt.asc"
  end
end
