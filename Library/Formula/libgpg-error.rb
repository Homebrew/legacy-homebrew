class LibgpgError < Formula
  homepage "http://www.gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.18.tar.bz2"
  mirror "http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.18.tar.bz2"
  sha1 "7ba54f939da023af8f5b3e7a421a32eb742909c4"

  bottle do
    cellar :any
    sha1 "2797742803d4b1529d5fd12a91e22ccbe8232511" => :yosemite
    sha1 "7b5d3ad9f1a7de9bb3766d2cbea98547b44ab342" => :mavericks
    sha1 "b8ae825c272dfe2e98f45d49dc5fdce803bafbe7" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
