class Ccrypt < Formula
  homepage "http://ccrypt.sourceforge.net/"
  url "http://ccrypt.sourceforge.net/download/ccrypt-1.10.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/ccrypt/ccrypt_1.10.orig.tar.gz"
  sha1 "95d4e524abb146946fe6af9d53ed0e5e294b34e2"

  fails_with :clang do
    build 318
    cause "Tests fail when optimizations are enabled"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
    system "make", "check"
  end

  test do
    touch "homebrew.txt"
    system bin/"ccrypt", "-e", testpath/"homebrew.txt", "-K", "secret"
    assert File.exist?("homebrew.txt.cpt")
    assert !File.exist?("homebrew.txt")

    system bin/"ccrypt", "-d", testpath/"homebrew.txt.cpt", "-K", "secret"
    assert File.exist?("homebrew.txt")
    assert !File.exist?("homebrew.txt.cpt")
  end
end
