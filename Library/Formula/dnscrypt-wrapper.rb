class DnscryptWrapper < Formula
  homepage "http://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/Cofyc/dnscrypt-wrapper/releases/download/v0.1.15/dnscrypt-wrapper-v0.1.15.tar.bz2"
  sha256 "d486f3f923c6809c830e9db39290b0f44b1683f63f8bd3aeaa6225c64af232c1"
  head "https://github.com/Cofyc/dnscrypt-wrapper.git"

  depends_on "autoconf" => :build

  depends_on "libsodium"
  depends_on "libevent"

  def install
    system "make", "configure"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dnscrypt-wrapper", "--gen-provider-keypair"
    system "#{bin}/dnscrypt-wrapper", "--gen-crypt-keypair"
  end
end
