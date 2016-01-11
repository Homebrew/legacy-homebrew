class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/Cofyc/dnscrypt-wrapper/releases/download/v0.2/dnscrypt-wrapper-v0.2.tar.bz2"
  sha256 "d26f9d6329653b71bed5978885385b45f16596021f219f46e49da60d5813054e"
  revision 2

  head "https://github.com/Cofyc/dnscrypt-wrapper.git"

  bottle do
    cellar :any
    sha256 "7fb6213e818bdc31f39f83b21b97aae817163b04e2711733c701094ff0459656" => :el_capitan
    sha256 "ad2f99446d0179e8354ab00210ed8d55f9d668955da1bffe4805e75daf3b6dfa" => :yosemite
    sha256 "697d6313d71f6effe50f7463da15738df33c4bd26f9c47c9c284292e36231c11" => :mavericks
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
