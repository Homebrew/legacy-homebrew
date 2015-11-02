class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/Cofyc/dnscrypt-wrapper/releases/download/v0.2/dnscrypt-wrapper-v0.2.tar.bz2"
  sha256 "d26f9d6329653b71bed5978885385b45f16596021f219f46e49da60d5813054e"
  head "https://github.com/Cofyc/dnscrypt-wrapper.git"
  revision 1

  bottle do
    cellar :any
    sha256 "ed9f28b79ec8400c8f837fe4bce0e5a02926b586c6a164dc7ed32c78ecce183f" => :el_capitan
    sha256 "3f109683a68405dbf9c402d9fb3e3156dff5a329949db702f0af4d4cfa71b513" => :yosemite
    sha256 "2066d2eebfe145a3ba2f234bce6887a276da630233ff98f3f0764de5d431ba47" => :mavericks
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
