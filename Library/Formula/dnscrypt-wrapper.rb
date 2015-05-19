class DnscryptWrapper < Formula
  desc "Server-side proxy that adds dnscrypt support to name resolvers"
  homepage "https://cofyc.github.io/dnscrypt-wrapper/"
  url "https://github.com/Cofyc/dnscrypt-wrapper/releases/download/v0.1.15/dnscrypt-wrapper-v0.1.15.tar.bz2"
  sha256 "d486f3f923c6809c830e9db39290b0f44b1683f63f8bd3aeaa6225c64af232c1"
  head "https://github.com/Cofyc/dnscrypt-wrapper.git"

  bottle do
    cellar :any
    sha1 "6275cdc455d328a0b1201c0b4dd6543487b42715" => :yosemite
    sha1 "384d364ee11cfb150b8072d303de6a7ed72ba450" => :mavericks
    sha1 "db2434e57e8deb88e066cc575ca1052076156eec" => :mountain_lion
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
    system "#{bin}/dnscrypt-wrapper", "--gen-provider-keypair"
    system "#{bin}/dnscrypt-wrapper", "--gen-crypt-keypair"
  end
end
