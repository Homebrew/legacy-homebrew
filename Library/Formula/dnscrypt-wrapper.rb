class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/Cofyc/dnscrypt-wrapper/releases/download/v0.2/dnscrypt-wrapper-v0.2.tar.bz2"
  sha256 "d26f9d6329653b71bed5978885385b45f16596021f219f46e49da60d5813054e"
  head "https://github.com/Cofyc/dnscrypt-wrapper.git"

  bottle do
    cellar :any
    sha256 "9a68b02511377f4912555eecc0b82d7bc0d29551fadabcd08436e2f73a338730" => :yosemite
    sha256 "bba2f1f2761a693f099eaaa4a34c6be2e1591ed86b1b07555401ddb6874cfe54" => :mavericks
    sha256 "c86c520f58207134ec8e365781cb7d8d80d4ff145d8c859ebca1518b565b5702" => :mountain_lion
  end

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
    system "#{sbin}/dnscrypt-wrapper", "--gen-provider-keypair"
    system "#{sbin}/dnscrypt-wrapper", "--gen-crypt-keypair"
  end
end
