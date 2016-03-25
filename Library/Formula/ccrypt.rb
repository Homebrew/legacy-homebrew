class Ccrypt < Formula
  desc "Encrypt and decrypt files and streams"
  homepage "http://ccrypt.sourceforge.net/"
  url "http://ccrypt.sourceforge.net/download/ccrypt-1.10.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/ccrypt/ccrypt_1.10.orig.tar.gz"
  sha256 "87d66da2170facabf6f2fc073586ae2c7320d4689980cfca415c74688e499ba0"

  bottle do
    sha256 "28709273d08ed2188def37735842b6c4ae576042f391ebaed975938366c7c5f6" => :el_capitan
    sha256 "a6772e44a314ed6bceacb544f5da9f6e3b5b5035007e4146a41b917d0017bcc7" => :yosemite
    sha256 "d5bbf02562843fa96d4e248aa8973e0434d7044f47840b1e506d9d43f2b2d1bf" => :mavericks
    sha256 "34eb45bc81353931dccf4b978857091073212a6a19dfde4d0e11479fb6a18ca8" => :mountain_lion
  end

  conflicts_with "ccat", :because => "both install `ccat` binaries"

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
